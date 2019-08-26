Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA6A59C773
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Aug 2019 04:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbfHZCxn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 25 Aug 2019 22:53:43 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:18319 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729361AbfHZCxn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 25 Aug 2019 22:53:43 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAAnl1+VSWNd09t8AQ--.37S2;
        Mon, 26 Aug 2019 10:53:09 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: Re: [PATCH v3 00/15] rbd journaling feature
To:     Ilya Dryomov <idryomov@gmail.com>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
 <CAOi1vP9G2MuEPd5cdia=44L_zvAQTM6bi_bn+eH1C-bV0ahAAA@mail.gmail.com>
Cc:     Jason Dillaman <jdillama@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Message-ID: <5D634994.5050300@easystack.cn>
Date:   Mon, 26 Aug 2019 10:53:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP9G2MuEPd5cdia=44L_zvAQTM6bi_bn+eH1C-bV0ahAAA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAAnl1+VSWNd09t8AQ--.37S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxKr45CrWUWr4xXw4Utw1xGrg_yoWxJw13pa
        nxGr13ArWUAr17Crs7Xa18ZryYv3y8trWUCrykGrn7Kwn8AF12qF4UtrWrCry7JryxGw1U
        Jr1Ut3WUGw1jyFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRIfO7UUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiThYdeldp-8c84AAAsl
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 08/19/2019 03:28 AM, Ilya Dryomov wrote:
> On Mon, Jul 29, 2019 at 11:43 AM Dongsheng Yang
> <dongsheng.yang@easystack.cn>  wrote:
>> Hi Ilya, Jason and all:
>>          As new exclusive-lock is merged, I think we can start this work now.
>> This is V3, which is rebased against 5.3-rc1.
>>
>> Testing:
>>          kernel branch:https://github.com/yangdongsheng/linux/tree/krbd_journaling_v3
>>          ceph qa branch:https://github.com/yangdongsheng/ceph/tree/krbd_mirror_qa
>>
>>          (1). A new test added: workunits/rbd/kernel_journal.sh: to test the journal replaying in krbd.
>>          (2). A new test added: qa/suites/krbd/mirror/, this test krbd journaling with rbd-mirror daemon.
>>
>> Performance:
>>          compared with librbd journaling, preformance of krbd journaling looks reasonable.
>>          -------------------------------------------------------------------------------------
>>          (1) rbd bench with journaling disabled:         |       IOPS: 114
>>          -------------------------------------------------------------------------------------
>>          (2) rbd bench with journaling enabled:          |       IOPS: 55
>>          -------------------------------------------------------------------------------------
>>          (3) fio krbd with journaling disabled:          |       IOPS: 118
>>          -------------------------------------------------------------------------------------
>>          (4) fio krbd with journaling enabled:           |       IOPS: 57
>>          -------------------------------------------------------------------------------------
>>
>> TODO:
>>          (1). there are some TODOs in comments, such as supporting rbd_journal_max_concurrent_object_sets.
>>          (2). add debugfs for generic journaling.
>>
>>          I would like to put this TODO work in next cycle, but focus on making  the current work ready to go.
>>
>> Changelog:
>>          -V2
>>                  1. support large event (> 4M)
>>                  2. fix bug in replay in different clients appending
>>                  3. rebase against 5.3-rc1
>>                  4. refactor journaler appending into state machine
>>          -V1
>>                  1. add test case in qa
>>                  2. address all memleak found in kmemleak
>>                  3. several bug fixes
>>                  4. performance improvement.
>>          -RFC
>>                  1. error out if there is some unsupported event type in replaying
>>                  2. just one memory copy from bio to msg.
>>                  3. use async IO in journal appending.
>>                  4. no mutex around IO.
>>
>> Any comments are welcome!!
>>
>> Dongsheng Yang (15):
>>    libceph: introduce ceph_extract_encoded_string_kvmalloc
>>    libceph: introduce a new parameter of workqueue in ceph_osdc_watch()
>>    libceph: support op append
>>    libceph: add prefix and suffix in ceph_osd_req_op.extent
>>    libceph: introduce cls_journaler_client
>>    libceph: introduce generic journaling
>>    libceph: journaling: introduce api to replay uncommitted journal
>>      events
>>    libceph: journaling: introduce api for journal appending
>>    libceph: journaling: trim object set when we found there is no client
>>      refer it
>>    rbd: introduce completion for each img_request
>>    rbd: introduce IMG_REQ_NOLOCK flag for image request state
>>    rbd: introduce rbd_journal_allocate_tag to allocate journal tag for
>>      rbd client
>>    rbd: append journal event in image request state machine
>>    rbd: replay events in journal
>>    rbd: add support for feature of RBD_FEATURE_JOURNALING
>>
>>   drivers/block/rbd.c                       |  600 +++++++-
>>   include/linux/ceph/cls_journaler_client.h |   94 ++
>>   include/linux/ceph/decode.h               |   21 +-
>>   include/linux/ceph/journaler.h            |  184 +++
>>   include/linux/ceph/osd_client.h           |   19 +
>>   net/ceph/Makefile                         |    3 +-
>>   net/ceph/cls_journaler_client.c           |  558 ++++++++
>>   net/ceph/journaler.c                      | 2231 +++++++++++++++++++++++++++++
>>   net/ceph/osd_client.c                     |   61 +-
>>   9 files changed, 3759 insertions(+), 12 deletions(-)
>>   create mode 100644 include/linux/ceph/cls_journaler_client.h
>>   create mode 100644 include/linux/ceph/journaler.h
>>   create mode 100644 net/ceph/cls_journaler_client.c
>>   create mode 100644 net/ceph/journaler.c
> Hi Dongsheng,
>
> Some general comments that apply to the whole series:
>
> - comments should look like
>
>    /* comment */
>
>    /*
>     * multi-line
>     * comment
>     */
>
> - placement of braces: a) don't use braces around single statements
>    (everywhere) and b) functions should have the opening brace on the
>    next line (e.g. rbd_img_need_journal())
>
> - 80 column limit: we aren't very strict about it, but overly long
>    lines should be the exception, not the rule
>
> - unnecessary forward declarations: just place the new function above
>    the call-site
>
> - sizeof(struct foo) should be sizeof(*foo_ptr)
>
> - integer types: use u{8,16,32,64} instead of uint{8,16,32,64}_t
>
> - static const variables should be defines (e.g. PREAMBLE)
>
> - no need to initialize fields to 0, NULL, etc after kzalloc() or
>    similar (e.g. ceph_journaler_open())
>
> Many of these rules are in Documentation/process/coding-style.rst.

Hi Ilya,
     Thanx for your suggestion about coding-style above, I will check my 
code again.
> Lastly, I would drop replaying for now.  This is a large series and
> replaying amounts to at least a quarter of it without actually solving
> the problem in its entirety.  Let's try to get appending and trimming
> in shape first.

I would like to keep replaying:
(1) The current replaying at least cover the all events generated from 
kernel rbd. So this feature looks self-consistent
I think.

That means, if you are only using krbd in your usecase, krbd journaling 
would works well. But if we drop replaying, I
am afraid we can't use journaling at all even when we are going to use 
krbd only.

(2) Even if we don't do replaying, we still have to do journal fetching 
and preprocess, to
know is there any uncommitted journal event. That's still a not small work.

(3) About solving the problem entirely, I actually had a plan in my mind.
we can provide an map option to user,
maybe "rbd map IMAGE -o 
journal-replay-helper=/usr/bin/rbd-journal-replay-helper.sh"

If this option is specified, we will use call_usermodehelper() to call 
the helper specified to do replay in journal opening.

else, we can use default replaying which is provided in this patch set.

Thanx
> Thanks,
>
>                  Ilya
>


