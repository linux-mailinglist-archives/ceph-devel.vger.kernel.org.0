Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 495EA5B027
	for <lists+ceph-devel@lfdr.de>; Sun, 30 Jun 2019 16:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfF3Ov1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 30 Jun 2019 10:51:27 -0400
Received: from gproxy1-pub.mail.unifiedlayer.com ([69.89.25.95]:34083 "EHLO
        gproxy1-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726525AbfF3Ov1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 30 Jun 2019 10:51:27 -0400
X-Greylist: delayed 2396 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Jun 2019 10:51:26 EDT
Received: from cmgw14.unifiedlayer.com (unknown [10.9.0.14])
        by gproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id 5E9CDBAD001D9
        for <ceph-devel@vger.kernel.org>; Sun, 30 Jun 2019 07:55:48 -0600 (MDT)
Received: from host449.hostmonster.com ([67.20.76.149])
        by cmsmtp with ESMTP
        id haJ2hADEbXFO5haJ2hbYtQ; Sun, 30 Jun 2019 07:55:48 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=petasan.org
        ; s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=P6Tt3hhKmuE+72Sz5XVXFk63HrA38z52/GtLY6T49Zk=; b=CSQa3NLQ4z2v22C6r4O3xTlZze
        B8dY70y4jYeg03vQP4sfzAVcAPGo8DjurmIYaUmLA4xqE50NkpvRXmXC4fu6VhA59TXEMQDEbulRo
        uMIh+6hJgBfFaKeOK7XhQUfzLWqxupONEd/SN5CbdCEdpLA/gA9mFF52EtbNThBITaXGajliLkPK3
        Qx7aPNp2exXKeDi7/i7ptDRKN11OrVJnlPhp1wo81mWAmTTE6oUgAGE/Y4oBndmBMdD+/zcFtG1r4
        shiQrUfL28u6WSD6zdDGCZ31aXYXdS29I+3GXTtZb9KpkqTenDuqLnQr6KqMCFYm++KV8htemLR/W
        NLS+LxQQ==;
Received: from [196.144.1.93] (port=3953 helo=[192.168.100.132])
        by host449.hostmonster.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <mmokhtar@petasan.org>)
        id 1hhaJ1-001AHQ-ID; Sun, 30 Jun 2019 07:55:48 -0600
Subject: Re: [PATCH 00/20] rbd: support for object-map and fast-diff
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
References: <20190625144111.11270-1-idryomov@gmail.com>
From:   Maged Mokhtar <mmokhtar@petasan.org>
Message-ID: <db51e9b9-1eed-2257-6201-2a43c3cdaf98@petasan.org>
Date:   Sun, 30 Jun 2019 15:55:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host449.hostmonster.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - petasan.org
X-BWhitelist: no
X-Source-IP: 196.144.1.93
X-Source-L: No
X-Exim-ID: 1hhaJ1-001AHQ-ID
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.100.132]) [196.144.1.93]:3953
X-Source-Auth: mmokhtar@petasan.org
X-Email-Count: 2
X-Source-Cap: cGV0YXNhbm87cGV0YXNhbm87aG9zdDQ0OS5ob3N0bW9uc3Rlci5jb20=
X-Local-Domain: yes
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



Hi Ilya,

Nice work. Some comments/questions:

1) Generally having a state machine makes things easier to track as the 
code is less dispersed than before.

2) The running_list is used to keep track of inflight requests in case 
of exclusive lock to support rbd_quiesce_lock() when releasing the lock. 
It would be great to generalize this list to keep track of all inflight 
requests even in the case when lock is not required, it could be used to 
support a generic flush (similar to librbd work queue flush/drain). 
Having a generic inflight requests list will also make it easier to 
support other functions such as task aborts, request timeouts, flushing 
on pre-snapshots.

3) For the acquiring_list, my concern is that while the lock is pending 
to be acquired, the requests are being accepted without a limit. In case 
there is a delay acquiring the lock, for example if the primary of the 
object header is down (which could block for ~ 25 sec) or worse if the 
pool is inactive, the count could well exceed the max queue depth + for 
write requests this can consume a lot of memory.

4) In rbd_img_exclusive_lock() at end, we queue an acquire lock task for 
every request. I understand this is a single threaded queue and if lock 
is acquired then all acquire tasks are cancelled, however i feel the 
queue could fill a lot. Any chance we can only schedule 1 acquire task ?

5) The state RBD_IMG_EXCLUSIVE_LOCK is used for both cases when image 
does not require exclusive lock + when lock is acquired. Cosmetically it 
may be better to separate them.

6) Probably not an issue, but we are now creating a large number of 
mutexes, at least 2 for every request. Maybe we need to test in high 
iops/queue depths that there is no overhead for this.

7) Is there any consideration to split the rbd module to multiple files 
? Looking at how big librbd, fitting this in a single kernel file is 
challenging at best.

/Maged

On 25/06/2019 16:40, Ilya Dryomov wrote:
> Hello,
> 
> This series adds support for object-map and fast-diff image features.
> Patches 1 - 11 prepare object and image request state machines; patches
> 12 - 14 fix most of the shortcomings in our exclusive lock code, making
> it suitable for guarding the object map; patches 15 - 18 take care of
> the prerequisites and finally patches 19 - 20 implement object-map and
> fast-diff.
> 
> Thanks,
> 
>                  Ilya
> 
> 
> Ilya Dryomov (20):
>    rbd: get rid of obj_req->xferred, obj_req->result and img_req->xferred
>    rbd: replace obj_req->tried_parent with obj_req->read_state
>    rbd: get rid of RBD_OBJ_WRITE_{FLAT,GUARD}
>    rbd: move OSD request submission into object request state machines
>    rbd: introduce image request state machine
>    rbd: introduce obj_req->osd_reqs list
>    rbd: factor out rbd_osd_setup_copyup()
>    rbd: factor out __rbd_osd_setup_discard_ops()
>    rbd: move OSD request allocation into object request state machines
>    rbd: rename rbd_obj_setup_*() to rbd_obj_init_*()
>    rbd: introduce copyup state machine
>    rbd: lock should be quiesced on reacquire
>    rbd: quiescing lock should wait for image requests
>    rbd: new exclusive lock wait/wake code
>    libceph: bump CEPH_MSG_MAX_DATA_LEN (again)
>    libceph: change ceph_osdc_call() to take page vector for response
>    libceph: export osd_req_op_data() macro
>    rbd: call rbd_dev_mapping_set() from rbd_dev_image_probe()
>    rbd: support for object-map and fast-diff
>    rbd: setallochint only if object doesn't exist
> 
>   drivers/block/rbd.c                  | 2433 ++++++++++++++++++--------
>   drivers/block/rbd_types.h            |   10 +
>   include/linux/ceph/cls_lock_client.h |    3 +
>   include/linux/ceph/libceph.h         |    6 +-
>   include/linux/ceph/osd_client.h      |   10 +-
>   include/linux/ceph/striper.h         |    2 +
>   net/ceph/cls_lock_client.c           |   47 +-
>   net/ceph/osd_client.c                |   18 +-
>   net/ceph/striper.c                   |   17 +
>   9 files changed, 1817 insertions(+), 729 deletions(-)
> 

