Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B24365B450
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfGAFqT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:46:19 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:43950 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfGAFqT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:46:19 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAAHAnX6nRldlKXwAA--.1630S2;
        Mon, 01 Jul 2019 13:45:31 +0800 (CST)
Subject: Re: [PATCH 00/20] rbd: support for object-map and fast-diff
To:     Maged Mokhtar <mmokhtar@petasan.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <db51e9b9-1eed-2257-6201-2a43c3cdaf98@petasan.org>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D199DFA.5070009@easystack.cn>
Date:   Mon, 1 Jul 2019 13:45:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <db51e9b9-1eed-2257-6201-2a43c3cdaf98@petasan.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAAHAnX6nRldlKXwAA--.1630S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGF4rCFyfCr4DZryxGF45Jrb_yoWrCw18pF
        Z0ga1Ykr95JF1Fywsaqa4kury8Gw48ZFW7XrySgr4IkF98WFnFvFWktay5ZryxWrZ7GrnF
        gr4DWFZxWF1Yy37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRna93UUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbichvkelmASuT4awAAsT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Maged,

On 06/30/2019 09:55 PM, Maged Mokhtar wrote:
>
>
> Hi Ilya,
>
> Nice work. Some comments/questions:
>
> 1) Generally having a state machine makes things easier to track as 
> the code is less dispersed than before.
>
> 2) The running_list is used to keep track of inflight requests in case 
> of exclusive lock to support rbd_quiesce_lock() when releasing the 
> lock. It would be great to generalize this list to keep track of all 
> inflight requests even in the case when lock is not required, it could 
> be used to support a generic flush (similar to librbd work queue 
> flush/drain). Having a generic inflight requests list will also make 
> it easier to support other functions such as task aborts, request 
> timeouts, flushing on pre-snapshots.
>
> 3) For the acquiring_list, my concern is that while the lock is 
> pending to be acquired, the requests are being accepted without a 
> limit. In case there is a delay acquiring the lock, for example if the 
> primary of the object header is down (which could block for ~ 25 sec) 
> or worse if the pool is inactive, the count could well exceed the max 
> queue depth + for write requests this can consume a lot of memory.
>
> 4) In rbd_img_exclusive_lock() at end, we queue an acquire lock task 
> for every request. I understand this is a single threaded queue and if 
> lock is acquired then all acquire tasks are cancelled, however i feel 
> the queue could fill a lot. Any chance we can only schedule 1 acquire 
> task ?
>
> 5) The state RBD_IMG_EXCLUSIVE_LOCK is used for both cases when image 
> does not require exclusive lock + when lock is acquired. Cosmetically 
> it may be better to separate them.
>
> 6) Probably not an issue, but we are now creating a large number of 
> mutexes, at least 2 for every request. Maybe we need to test in high 
> iops/queue depths that there is no overhead for this.
>
> 7) Is there any consideration to split the rbd module to multiple 
> files ? Looking at how big librbd, fitting this in a single kernel 
> file is challenging at best.

Ilya could provide more information, but I can share something about 
this. Ilya and I had a discussion about splitting rbd.c as it is really 
big enough. But we want something WIP (this patchset)
could be merged firstly. A rough idea is pulling exclusive-lock and 
object-map out from rbd.c.

Thanx
>
> /Maged
>
> On 25/06/2019 16:40, Ilya Dryomov wrote:
>> Hello,
>>
>> This series adds support for object-map and fast-diff image features.
>> Patches 1 - 11 prepare object and image request state machines; patches
>> 12 - 14 fix most of the shortcomings in our exclusive lock code, making
>> it suitable for guarding the object map; patches 15 - 18 take care of
>> the prerequisites and finally patches 19 - 20 implement object-map and
>> fast-diff.
>>
>> Thanks,
>>
>>                  Ilya
>>
>>
>> Ilya Dryomov (20):
>>    rbd: get rid of obj_req->xferred, obj_req->result and 
>> img_req->xferred
>>    rbd: replace obj_req->tried_parent with obj_req->read_state
>>    rbd: get rid of RBD_OBJ_WRITE_{FLAT,GUARD}
>>    rbd: move OSD request submission into object request state machines
>>    rbd: introduce image request state machine
>>    rbd: introduce obj_req->osd_reqs list
>>    rbd: factor out rbd_osd_setup_copyup()
>>    rbd: factor out __rbd_osd_setup_discard_ops()
>>    rbd: move OSD request allocation into object request state machines
>>    rbd: rename rbd_obj_setup_*() to rbd_obj_init_*()
>>    rbd: introduce copyup state machine
>>    rbd: lock should be quiesced on reacquire
>>    rbd: quiescing lock should wait for image requests
>>    rbd: new exclusive lock wait/wake code
>>    libceph: bump CEPH_MSG_MAX_DATA_LEN (again)
>>    libceph: change ceph_osdc_call() to take page vector for response
>>    libceph: export osd_req_op_data() macro
>>    rbd: call rbd_dev_mapping_set() from rbd_dev_image_probe()
>>    rbd: support for object-map and fast-diff
>>    rbd: setallochint only if object doesn't exist
>>
>>   drivers/block/rbd.c                  | 2433 ++++++++++++++++++--------
>>   drivers/block/rbd_types.h            |   10 +
>>   include/linux/ceph/cls_lock_client.h |    3 +
>>   include/linux/ceph/libceph.h         |    6 +-
>>   include/linux/ceph/osd_client.h      |   10 +-
>>   include/linux/ceph/striper.h         |    2 +
>>   net/ceph/cls_lock_client.c           |   47 +-
>>   net/ceph/osd_client.c                |   18 +-
>>   net/ceph/striper.c                   |   17 +
>>   9 files changed, 1817 insertions(+), 729 deletions(-)
>>
>
>


