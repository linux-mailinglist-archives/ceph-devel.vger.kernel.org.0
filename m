Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 602A75B026
	for <lists+ceph-devel@lfdr.de>; Sun, 30 Jun 2019 16:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfF3Ony (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 30 Jun 2019 10:43:54 -0400
Received: from gproxy9-pub.mail.unifiedlayer.com ([69.89.20.122]:33554 "EHLO
        gproxy9-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726500AbfF3Ony (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 30 Jun 2019 10:43:54 -0400
X-Greylist: delayed 1411 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Jun 2019 10:43:53 EDT
Received: from CMGW (unknown [10.9.0.13])
        by gproxy9.mail.unifiedlayer.com (Postfix) with ESMTP id 508DA1E0655
        for <ceph-devel@vger.kernel.org>; Sun, 30 Jun 2019 08:20:21 -0600 (MDT)
Received: from host449.hostmonster.com ([67.20.76.149])
        by cmsmtp with ESMTP
        id hagnh7lzSeyBxhagnhOke2; Sun, 30 Jun 2019 08:20:21 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=petasan.org
        ; s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SvjjW6xp9+k40o0Iy3pYBM/WCpaPquw+lyhZWHXbYAk=; b=Gmg4VtazdPbWa3V2jqbhSEXY+l
        WDRS9lgC5cAl3ehrciawjmyeRpNhLevptpv7TbAecGpVvJ7/b7slfLey4U/yR0FWTxdMleijz1oss
        p1u71Ccb2cRdMPZ7mDpQsGOewfesaDLW1MAn58JzQS/uI9pte51jzU7E1tbTtgYYk1slKjE/WW66Y
        6AcKKU3AYbAMF8dKZfhsVHMnQvtB1CdIEDdkPy5+sdpC5277JKn+KrIxvf3KyyJkhk1MgKU41V888
        9d6kndDmiAkkzTpANebwgxriYzz14rIhYpqyq7JLczwPmnw/NWTFQ2fSge2xvS5Rd2w5zGwzNCSN6
        dncdRTGw==;
Received: from [196.144.1.93] (port=3948 helo=[192.168.100.132])
        by host449.hostmonster.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <mmokhtar@petasan.org>)
        id 1hhagm-001KQX-HN; Sun, 30 Jun 2019 08:20:21 -0600
Subject: Re: [PATCH 00/20] rbd: support for object-map and fast-diff
From:   Maged Mokhtar <mmokhtar@petasan.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
References: <20190625144111.11270-1-idryomov@gmail.com>
 <db51e9b9-1eed-2257-6201-2a43c3cdaf98@petasan.org>
Message-ID: <4c3489b7-4d8d-56d1-ed46-e7927eac98bf@petasan.org>
Date:   Sun, 30 Jun 2019 16:20:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <db51e9b9-1eed-2257-6201-2a43c3cdaf98@petasan.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host449.hostmonster.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - petasan.org
X-BWhitelist: no
X-Source-IP: 196.144.1.93
X-Source-L: No
X-Exim-ID: 1hhagm-001KQX-HN
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.100.132]) [196.144.1.93]:3948
X-Source-Auth: mmokhtar@petasan.org
X-Email-Count: 2
X-Source-Cap: cGV0YXNhbm87cGV0YXNhbm87aG9zdDQ0OS5ob3N0bW9uc3Rlci5jb20=
X-Local-Domain: yes
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



re-reading 3), i realize the queue depth will not be exceeded in the 
request queue.


On 30/06/2019 15:55, Maged Mokhtar wrote:
> 
> 
> Hi Ilya,
> 
> Nice work. Some comments/questions:
> 
> 1) Generally having a state machine makes things easier to track as the 
> code is less dispersed than before.
> 
> 2) The running_list is used to keep track of inflight requests in case 
> of exclusive lock to support rbd_quiesce_lock() when releasing the lock. 
> It would be great to generalize this list to keep track of all inflight 
> requests even in the case when lock is not required, it could be used to 
> support a generic flush (similar to librbd work queue flush/drain). 
> Having a generic inflight requests list will also make it easier to 
> support other functions such as task aborts, request timeouts, flushing 
> on pre-snapshots.
> 
> 3) For the acquiring_list, my concern is that while the lock is pending 
> to be acquired, the requests are being accepted without a limit. In case 
> there is a delay acquiring the lock, for example if the primary of the 
> object header is down (which could block for ~ 25 sec) or worse if the 
> pool is inactive, the count could well exceed the max queue depth + for 
> write requests this can consume a lot of memory.
> 
> 4) In rbd_img_exclusive_lock() at end, we queue an acquire lock task for 
> every request. I understand this is a single threaded queue and if lock 
> is acquired then all acquire tasks are cancelled, however i feel the 
> queue could fill a lot. Any chance we can only schedule 1 acquire task ?
> 
> 5) The state RBD_IMG_EXCLUSIVE_LOCK is used for both cases when image 
> does not require exclusive lock + when lock is acquired. Cosmetically it 
> may be better to separate them.
> 
> 6) Probably not an issue, but we are now creating a large number of 
> mutexes, at least 2 for every request. Maybe we need to test in high 
> iops/queue depths that there is no overhead for this.
> 
> 7) Is there any consideration to split the rbd module to multiple files 
> ? Looking at how big librbd, fitting this in a single kernel file is 
> challenging at best.
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
>>                  Ilya
>>
>>
>> Ilya Dryomov (20):
>>    rbd: get rid of obj_req->xferred, obj_req->result and img_req->xferred
>>    rbd: replace obj_req->tried_parent with obj_req->read_state
>>    rbd: get rid of RBD_OBJ_WRITE_{FLAT,GUARD}
>>    rbd: move OSD request submission into object request state machines
>>    rbd: introduce image request state machine
>>    rbd: introduce obj_req->osd_reqs list
>>    rbd: factor out rbd_osd_setup_copyup()
>>    rbd: factor out __rbd_osd_setup_discard_ops()
>>    rbd: move OSD request allocation into object request state machines
>>    rbd: rename rbd_obj_setup_*() to rbd_obj_init_*()
>>    rbd: introduce copyup state machine
>>    rbd: lock should be quiesced on reacquire
>>    rbd: quiescing lock should wait for image requests
>>    rbd: new exclusive lock wait/wake code
>>    libceph: bump CEPH_MSG_MAX_DATA_LEN (again)
>>    libceph: change ceph_osdc_call() to take page vector for response
>>    libceph: export osd_req_op_data() macro
>>    rbd: call rbd_dev_mapping_set() from rbd_dev_image_probe()
>>    rbd: support for object-map and fast-diff
>>    rbd: setallochint only if object doesn't exist
>>
>>   drivers/block/rbd.c                  | 2433 ++++++++++++++++++--------
>>   drivers/block/rbd_types.h            |   10 +
>>   include/linux/ceph/cls_lock_client.h |    3 +
>>   include/linux/ceph/libceph.h         |    6 +-
>>   include/linux/ceph/osd_client.h      |   10 +-
>>   include/linux/ceph/striper.h         |    2 +
>>   net/ceph/cls_lock_client.c           |   47 +-
>>   net/ceph/osd_client.c                |   18 +-
>>   net/ceph/striper.c                   |   17 +
>>   9 files changed, 1817 insertions(+), 729 deletions(-)
>>
> 

-- 
Maged Mokhtar
CEO PetaSAN
4 Emad El Deen Kamel
Cairo 11371, Egypt
www.petasan.org
+201006979931
skype: maged.mokhtar
