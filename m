Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F325B431
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfGAFeV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:34:21 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:23692 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbfGAFeV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:34:21 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowACXl7dcmxldD4rwAA--.1421S2;
        Mon, 01 Jul 2019 13:34:20 +0800 (CST)
Subject: Re: [PATCH 00/20] rbd: support for object-map and fast-diff
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D199B5B.3060203@easystack.cn>
Date:   Mon, 1 Jul 2019 13:34:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowACXl7dcmxldD4rwAA--.1421S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4iZjjaUUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbibxzkellZungeHQAAss
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Ilya,

On 06/25/2019 10:40 PM, Ilya Dryomov wrote:
> Hello,
>
> This series adds support for object-map and fast-diff image features.
> Patches 1 - 11 prepare object and image request state machines; patches
> 12 - 14 fix most of the shortcomings in our exclusive lock code, making
> it suitable for guarding the object map; patches 15 - 18 take care of
> the prerequisites and finally patches 19 - 20 implement object-map and
> fast-diff.

Nice patchset. I did review and a testing for this patchset.

TEST:
       with object-map enabled, I found a case failed: 
tasks/rbd_kernel.yaml.
It failed to rollback test_img while test_img is mapped.

Thanx
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


