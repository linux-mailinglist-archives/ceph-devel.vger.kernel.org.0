Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9A8F91940
	for <lists+ceph-devel@lfdr.de>; Sun, 18 Aug 2019 21:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfHRTZ5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 18 Aug 2019 15:25:57 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43054 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfHRTZ5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 18 Aug 2019 15:25:57 -0400
Received: by mail-io1-f67.google.com with SMTP id 18so16287643ioe.10
        for <ceph-devel@vger.kernel.org>; Sun, 18 Aug 2019 12:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pq2FXu03P6QvUMRaiu27wlde+Kq0vR5SmnK/5y9UIvc=;
        b=j2cTI42WrnY8MPbXNkbw+mMI91njGH6DF+2R2BGiKjZTBnVsKBoQt+yUjKR9sEEdVL
         gNM91j+Zvfda0p/UUt99k2Z78LA99UMyMVq75dB0DwDhaKfUNYwr4qPLb1EdN1xP6BJj
         eY7HsKg+2li5JYtOaX19OWSIcU7v/sja47OGD57hOZ7FV6p4MzWcV0iYwiB04UNO8VIH
         zRgiw6NhIyR1cEI/9u0mWqrDEu8heN4ZS+OF6rhC9b393BSDucwk6CUzSpnQ6QBNG67o
         zaCp2ehUH1pgYeO0CslZp9o9wGEaq84mYx21BX40ZOXEpCvLwIUnR8A20nmKfjOy9hMl
         cHEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pq2FXu03P6QvUMRaiu27wlde+Kq0vR5SmnK/5y9UIvc=;
        b=PKnmeFvU68Al007m4V6De8r6zluD5qBQFeki4PcfigftobxaufdcFl8KFJ3GrlHCAY
         WarA0m7k+edmjawAkQG8QRUnISTVFVFAzicYYg6KGkQkeYUwi5STr7EWJvA+A8e1rqDP
         Sf322WpB8V6uC4sGhOdXFYkTNlVbnIOUZQ926TDWOCYTjXD/8oWj/aeR1uUnNpOoaBXc
         tubUbCSNpLQTYrKANBSXCRLwzw++pIELsNADz/xtcMeQW8l4nN5yc+zHLpkIwNJhvDLK
         UFnBVQeMkxCvCRvVgSi7XVfg+vQkU6j2yrSMhbwWFr9hWcL5kC+ho7DJqzvtsC2Cs3I/
         t2gg==
X-Gm-Message-State: APjAAAV6I5CL9PAxEcLf2lGSkOvhG9NolG1fhT72NZq+U3XXmateIPtA
        UXIB/pHHGZ5yY6AIyErTpUWrLFZ4P0ik3XnK7oY=
X-Google-Smtp-Source: APXvYqyJh3CYEl4808Y2pdAMmd/+3bv4inoIWyRFdxACVM+7UcXEhuLuMbtp7Aui8fvMAs4chYVvKliznhJOUzSiseI=
X-Received: by 2002:a6b:6607:: with SMTP id a7mr2765115ioc.215.1566156356630;
 Sun, 18 Aug 2019 12:25:56 -0700 (PDT)
MIME-Version: 1.0
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
In-Reply-To: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Sun, 18 Aug 2019 21:28:56 +0200
Message-ID: <CAOi1vP9G2MuEPd5cdia=44L_zvAQTM6bi_bn+eH1C-bV0ahAAA@mail.gmail.com>
Subject: Re: [PATCH v3 00/15] rbd journaling feature
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Jason Dillaman <jdillama@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 29, 2019 at 11:43 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
> Hi Ilya, Jason and all:
>         As new exclusive-lock is merged, I think we can start this work now.
> This is V3, which is rebased against 5.3-rc1.
>
> Testing:
>         kernel branch: https://github.com/yangdongsheng/linux/tree/krbd_journaling_v3
>         ceph qa branch: https://github.com/yangdongsheng/ceph/tree/krbd_mirror_qa
>
>         (1). A new test added: workunits/rbd/kernel_journal.sh: to test the journal replaying in krbd.
>         (2). A new test added: qa/suites/krbd/mirror/, this test krbd journaling with rbd-mirror daemon.
>
> Performance:
>         compared with librbd journaling, preformance of krbd journaling looks reasonable.
>         -------------------------------------------------------------------------------------
>         (1) rbd bench with journaling disabled:         |       IOPS: 114
>         -------------------------------------------------------------------------------------
>         (2) rbd bench with journaling enabled:          |       IOPS: 55
>         -------------------------------------------------------------------------------------
>         (3) fio krbd with journaling disabled:          |       IOPS: 118
>         -------------------------------------------------------------------------------------
>         (4) fio krbd with journaling enabled:           |       IOPS: 57
>         -------------------------------------------------------------------------------------
>
> TODO:
>         (1). there are some TODOs in comments, such as supporting rbd_journal_max_concurrent_object_sets.
>         (2). add debugfs for generic journaling.
>
>         I would like to put this TODO work in next cycle, but focus on making  the current work ready to go.
>
> Changelog:
>         -V2
>                 1. support large event (> 4M)
>                 2. fix bug in replay in different clients appending
>                 3. rebase against 5.3-rc1
>                 4. refactor journaler appending into state machine
>         -V1
>                 1. add test case in qa
>                 2. address all memleak found in kmemleak
>                 3. several bug fixes
>                 4. performance improvement.
>         -RFC
>                 1. error out if there is some unsupported event type in replaying
>                 2. just one memory copy from bio to msg.
>                 3. use async IO in journal appending.
>                 4. no mutex around IO.
>
> Any comments are welcome!!
>
> Dongsheng Yang (15):
>   libceph: introduce ceph_extract_encoded_string_kvmalloc
>   libceph: introduce a new parameter of workqueue in ceph_osdc_watch()
>   libceph: support op append
>   libceph: add prefix and suffix in ceph_osd_req_op.extent
>   libceph: introduce cls_journaler_client
>   libceph: introduce generic journaling
>   libceph: journaling: introduce api to replay uncommitted journal
>     events
>   libceph: journaling: introduce api for journal appending
>   libceph: journaling: trim object set when we found there is no client
>     refer it
>   rbd: introduce completion for each img_request
>   rbd: introduce IMG_REQ_NOLOCK flag for image request state
>   rbd: introduce rbd_journal_allocate_tag to allocate journal tag for
>     rbd client
>   rbd: append journal event in image request state machine
>   rbd: replay events in journal
>   rbd: add support for feature of RBD_FEATURE_JOURNALING
>
>  drivers/block/rbd.c                       |  600 +++++++-
>  include/linux/ceph/cls_journaler_client.h |   94 ++
>  include/linux/ceph/decode.h               |   21 +-
>  include/linux/ceph/journaler.h            |  184 +++
>  include/linux/ceph/osd_client.h           |   19 +
>  net/ceph/Makefile                         |    3 +-
>  net/ceph/cls_journaler_client.c           |  558 ++++++++
>  net/ceph/journaler.c                      | 2231 +++++++++++++++++++++++++++++
>  net/ceph/osd_client.c                     |   61 +-
>  9 files changed, 3759 insertions(+), 12 deletions(-)
>  create mode 100644 include/linux/ceph/cls_journaler_client.h
>  create mode 100644 include/linux/ceph/journaler.h
>  create mode 100644 net/ceph/cls_journaler_client.c
>  create mode 100644 net/ceph/journaler.c

Hi Dongsheng,

Some general comments that apply to the whole series:

- comments should look like

  /* comment */

  /*
   * multi-line
   * comment
   */

- placement of braces: a) don't use braces around single statements
  (everywhere) and b) functions should have the opening brace on the
  next line (e.g. rbd_img_need_journal())

- 80 column limit: we aren't very strict about it, but overly long
  lines should be the exception, not the rule

- unnecessary forward declarations: just place the new function above
  the call-site

- sizeof(struct foo) should be sizeof(*foo_ptr)

- integer types: use u{8,16,32,64} instead of uint{8,16,32,64}_t

- static const variables should be defines (e.g. PREAMBLE)

- no need to initialize fields to 0, NULL, etc after kzalloc() or
  similar (e.g. ceph_journaler_open())

Many of these rules are in Documentation/process/coding-style.rst.

Lastly, I would drop replaying for now.  This is a large series and
replaying amounts to at least a quarter of it without actually solving
the problem in its entirety.  Let's try to get appending and trimming
in shape first.

Thanks,

                Ilya
