Return-Path: <ceph-devel+bounces-874-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 929D1859419
	for <lists+ceph-devel@lfdr.de>; Sun, 18 Feb 2024 03:33:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3CE5CB21722
	for <lists+ceph-devel@lfdr.de>; Sun, 18 Feb 2024 02:33:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EE1315CB;
	Sun, 18 Feb 2024 02:33:44 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B168C376;
	Sun, 18 Feb 2024 02:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708223624; cv=none; b=oNeenRmQY5GwG9LKRoQ9mPpXBFwHGxaxAgGOdl0IP+jUCI+I3YhBezGD5LIPNLzEG1qJt2u19iud6wKikytooFr468YdOKeTCpL6TKdAh2AjHIFuUxlXA7xnT5cADbFFnV+N2eUvaIUPsljzefn9P4ilaXV42ZmxCrED+EK4ODk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708223624; c=relaxed/simple;
	bh=k1CAJJG7cwRcOmzPDTOHpD65ijwN1N1laTyLUY8E9mE=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ujKiJyO5NhpbVtviaD+TTudLfCaP8fREDm5+VQg2Lt39DJhYRcZwgvc+3wZqkLBF2ucFz9R7R1m+DAO0WkaKoMZtC+EACvnwFZt83iYhjd7hcDI+a6zZTCXlZ3CSeynwa96Skte7Mo2yMYFLbIqzr8nN5hjjvSxbKj5jdp/slTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4TcqSj2TRzz1xmkD;
	Sun, 18 Feb 2024 10:32:21 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (unknown [7.193.23.68])
	by mail.maildlp.com (Postfix) with ESMTPS id 546CF1400CC;
	Sun, 18 Feb 2024 10:33:40 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 18 Feb 2024 10:33:38 +0800
Subject: Re: [PATCH 14/17] ubiblock: pass queue_limits to blk_mq_alloc_disk
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: Richard Weinberger <richard@nod.at>, Anton Ivanov
	<anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>,
	Justin Sanders <justin@coraid.com>, Denis Efremov <efremov@linux.com>, Josef
 Bacik <josef@toxicpanda.com>, Geoff Levand <geoff@infradead.org>, Ilya
 Dryomov <idryomov@gmail.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack
 Wang <jinpu.wang@ionos.com>, Ming Lei <ming.lei@redhat.com>, Maxim Levitsky
	<maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>, Ulf Hansson
	<ulf.hansson@linaro.org>, Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh
 Raghavendra <vigneshr@ti.com>, Vineeth Vijayan <vneethv@linux.ibm.com>,
	<linux-block@vger.kernel.org>, <nbd@other.debian.org>,
	<ceph-devel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-mtd@lists.infradead.org>, <linux-s390@vger.kernel.org>
References: <20240215070300.2200308-1-hch@lst.de>
 <20240215070300.2200308-15-hch@lst.de>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <6b559ea2-944e-c5f6-f7ce-1119c5369a48@huawei.com>
Date: Sun, 18 Feb 2024 10:33:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240215070300.2200308-15-hch@lst.de>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600013.china.huawei.com (7.193.23.68)

ÔÚ 2024/2/15 15:02, Christoph Hellwig Ð´µÀ:
> Pass the few limits ubiblock imposes directly to blk_mq_alloc_disk
> instead of setting them one at a time.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/mtd/ubi/block.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)

Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
> 
> diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
> index 9be87c231a2eba..5c8fdcc088a0df 100644
> --- a/drivers/mtd/ubi/block.c
> +++ b/drivers/mtd/ubi/block.c
> @@ -348,6 +348,9 @@ static int calc_disk_capacity(struct ubi_volume_info *vi, u64 *disk_capacity)
>   
>   int ubiblock_create(struct ubi_volume_info *vi)
>   {
> +	struct queue_limits lim = {
> +		.max_segments		= UBI_MAX_SG_COUNT,
> +	};
>   	struct ubiblock *dev;
>   	struct gendisk *gd;
>   	u64 disk_capacity;
> @@ -393,7 +396,7 @@ int ubiblock_create(struct ubi_volume_info *vi)
>   
>   
>   	/* Initialize the gendisk of this ubiblock device */
> -	gd = blk_mq_alloc_disk(&dev->tag_set, NULL, dev);
> +	gd = blk_mq_alloc_disk(&dev->tag_set, &lim, dev);
>   	if (IS_ERR(gd)) {
>   		ret = PTR_ERR(gd);
>   		goto out_free_tags;
> @@ -416,7 +419,6 @@ int ubiblock_create(struct ubi_volume_info *vi)
>   	dev->gd = gd;
>   
>   	dev->rq = gd->queue;
> -	blk_queue_max_segments(dev->rq, UBI_MAX_SG_COUNT);
>   
>   	list_add_tail(&dev->list, &ubiblock_devices);
>   
> 


