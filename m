Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80803101DDF
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 09:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfKSIiO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 03:38:14 -0500
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:3713 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfKSIiO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 03:38:14 -0500
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowACHZmXyqdNdFRjvAw--.111S2;
        Tue, 19 Nov 2019 16:38:10 +0800 (CST)
Subject: Re: [PATCH 9/9] rbd: ask for a weaker incompat mask for read-only
 mappings
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20191118133816.3963-1-idryomov@gmail.com>
 <20191118133816.3963-10-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5DD3A9F2.4070304@easystack.cn>
Date:   Tue, 19 Nov 2019 16:38:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20191118133816.3963-10-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowACHZmXyqdNdFRjvAw--.111S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRNGYJUUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbicBNyellZu0T8eQAAsR
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 11/18/2019 09:38 PM, Ilya Dryomov wrote:
> For a read-only mapping, ask for a set of features that make the image
> only unreadable, rather than both unreadable and unwritable by a client
> that doesn't understand them.  As of today, the difference between them
> for krbd is journaling (JOURNALING) and live migration (MIGRATING).
>
> get_features method supports read_only parameter since hammer, ceph.git
> commit 6176ec5fde2a ("librbd: differentiate between R/O vs R/W RBD
> features").
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 935b66808e40..b3167247c90a 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -5652,9 +5652,12 @@ static int rbd_dev_v2_object_prefix(struct rbd_device *rbd_dev)
>   }
>   
>   static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
> -		u64 *snap_features)
> +				     bool read_only, u64 *snap_features)
>   {
> -	__le64 snapid = cpu_to_le64(snap_id);
> +	struct {
> +		__le64 snap_id;
> +		u8 read_only;
> +	} features_in;
>   	struct {
>   		__le64 features;
>   		__le64 incompat;
> @@ -5662,9 +5665,12 @@ static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
>   	u64 unsup;
>   	int ret;
>   
> +	features_in.snap_id = cpu_to_le64(snap_id);
> +	features_in.read_only = read_only;
> +
>   	ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
>   				  &rbd_dev->header_oloc, "get_features",
> -				  &snapid, sizeof(snapid),
> +				  &features_in, sizeof(features_in),
>   				  &features_buf, sizeof(features_buf));
>   	dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
>   	if (ret < 0)
> @@ -5692,7 +5698,8 @@ static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
>   static int rbd_dev_v2_features(struct rbd_device *rbd_dev)
>   {
>   	return _rbd_dev_v2_snap_features(rbd_dev, CEPH_NOSNAP,
> -						&rbd_dev->header.features);
> +					 rbd_is_ro(rbd_dev),
> +					 &rbd_dev->header.features);
>   }
>   
>   /*


