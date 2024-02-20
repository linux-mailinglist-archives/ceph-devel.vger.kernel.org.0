Return-Path: <ceph-devel+bounces-882-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5531E85BA2E
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Feb 2024 12:19:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A50C1C23C99
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Feb 2024 11:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02A61664BB;
	Tue, 20 Feb 2024 11:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jzBjwymk"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223E765BD9;
	Tue, 20 Feb 2024 11:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708427938; cv=none; b=LovNWBrJgKhWqNO2R15LlVLTpMRZaAb0bD63L/bFrf7/IfjW2gruxoamfvyilHTGQDbTXWoqH8M2N9wd+ZeKXrjHH4Po/s9ZDU311B2xjtxZ8eOzmORKJ5VABgLGbxX2+I9bVFTW44IDD79dTnQmC+mJIJNsqskhmEEy4XWj5YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708427938; c=relaxed/simple;
	bh=EUGtUfVHDff9tyqyS13cOvf6pLSq+DFA2mtqIG6XRrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D1WxPL2BygUX9VrO06Ls0fHjDCWB1aJ2gCetn48TYB0fCcb4t6tEIAZVEaZ6DN09ir7kMD6YktRX7H/Rsj0LpQDSVrmdQLWS6p+d7f9vnmnv+HqmLzim+KhOnDaWe2GjWGK1HTeLbFy0LHLbSU3vhSa6HJTEfeBU0Nl+VoVFOwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jzBjwymk; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3c132695f1bso4070475b6e.2;
        Tue, 20 Feb 2024 03:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708427936; x=1709032736; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QnXxqyxgAOCE9B1gsdMTfmeu8SJJIbR4o3Oy9m1fJBo=;
        b=jzBjwymkV9MuUowIWG+XBioG4DtqBvq1rrVex/sM0oSBWEAZdotEO5ii0mKQWeTHfe
         hAU+nF6yicbTzgg9s3zfevDEmbwVAEQY9i6LDJefHSJyJT/BiaJntQes6YV2qPfJgK6D
         Deg4lGxvkUFHmrLlR1uzbpW4RUkfDogmsZCy+v2ADlT6Of19wz99N5wzwxCrAcQcPfme
         chMckhc7HRI9myI6y0s3aEOe44Z+BBBRQjFaYAWbWlbWoq92DP5my8JGEp2ofS1Dcspf
         Vtdex59rW0aO/RaTswQHmqIzlYQW/hRJntkcGL5sPzm0g3SKtF3XiYwLXxnOLddypmZY
         Wg4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708427936; x=1709032736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QnXxqyxgAOCE9B1gsdMTfmeu8SJJIbR4o3Oy9m1fJBo=;
        b=EK8PyW5zyFQHoykAkz5UmU9ZrUfrE+5hBufo+q0lcT1LGMR86oyuh3IdgUFq8SsKI/
         FgmjDNQp0J7LlfMAakriXqi2Fdi6Qyj0lsFj83p5+NHvaPHIlFh8fE5z2FYv0Qn57jdn
         MPgvRoA3pzdguALjF5VBS/lx0dNdnHdYhGDs0TTy1tQTJpJnsCXLhcY1CIS+syePBBYd
         KP0F87p+Ks4zPLE4Rdgd/DiEVgsa19OrSYni9h/dUtLxE0/YRizovm1TmXIDlEDT1VsA
         z6JI2nIDb2kH02aNRZF27Lr4y30NFqCFn9wuEFn7VE6xnh0wWbAafTeMlKyXwx/Bk6aZ
         zjPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDr5Zv5OMX+tA7XBuKJA00VdckH/HxzDESfqL4Yd75w9a9ihCcDsoK3VTE9l8JvelziWAQwmS3ZyEbCT2IEqXLQbsJRMBjbzTpWRhnHTsEy1ENzFa6BXu8YxboIaFNj2QkY8RINg/8H2LqrFOg0jHkDmYwjPPVhvlCz5WKe1XzJLtjBVA61kV1Vm1HWQX9doszA+uG+ibVfN8ylHs7pQ==
X-Gm-Message-State: AOJu0YyPLSA3cbkpNjmN4Hsu24It7AHgPKSMCzQuk1JLfq8QwyGS2Slv
	IWam7xyPHqQub3QacfcGcw5uXI/JSFcGHRppmAIWDTB/Ho+UkcuSorsP1CaStNV3KXIPD3JI22v
	/OaEs1I+Pk7fjg97pwiiA/1Lj1og=
X-Google-Smtp-Source: AGHT+IFqXfo9MqRRXkJHVGd1zP5btF8tonhuNN58hdV1sWRe6/06+YeQrZc/xVd+r5scxRDkntVJIrsGV3fU9rwHZzE=
X-Received: by 2002:a05:6808:201a:b0:3c1:5fa3:ab8 with SMTP id
 q26-20020a056808201a00b003c15fa30ab8mr4610653oiw.39.1708427936094; Tue, 20
 Feb 2024 03:18:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215070300.2200308-1-hch@lst.de> <20240215070300.2200308-8-hch@lst.de>
In-Reply-To: <20240215070300.2200308-8-hch@lst.de>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 20 Feb 2024 12:18:44 +0100
Message-ID: <CAOi1vP9K=YYrtuCGF5B41He8D5q2zSmiCHjHezo0Dgu1gKH4+w@mail.gmail.com>
Subject: Re: [PATCH 07/17] rbd: pass queue_limits to blk_mq_alloc_disk
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Justin Sanders <justin@coraid.com>, Denis Efremov <efremov@linux.com>, 
	Josef Bacik <josef@toxicpanda.com>, Geoff Levand <geoff@infradead.org>, 
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, 
	Ming Lei <ming.lei@redhat.com>, Maxim Levitsky <maximlevitsky@gmail.com>, 
	Alex Dubov <oakad@yahoo.com>, Ulf Hansson <ulf.hansson@linaro.org>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Vineeth Vijayan <vneethv@linux.ibm.com>, linux-block@vger.kernel.org, nbd@other.debian.org, 
	ceph-devel@vger.kernel.org, linux-mmc@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 15, 2024 at 8:03=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Pass the limits rbd imposes directly to blk_mq_alloc_disk instead
> of setting them one at a time.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/rbd.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 6b4f1898a722a3..26ff5cd2bf0abc 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -4952,6 +4952,14 @@ static int rbd_init_disk(struct rbd_device *rbd_de=
v)
>         struct request_queue *q;
>         unsigned int objset_bytes =3D
>             rbd_dev->layout.object_size * rbd_dev->layout.stripe_count;
> +       struct queue_limits lim =3D {
> +               .max_hw_sectors         =3D objset_bytes >> SECTOR_SHIFT,
> +               .max_user_sectors       =3D objset_bytes >> SECTOR_SHIFT,
> +               .io_min                 =3D rbd_dev->opts->alloc_size,
> +               .io_opt                 =3D rbd_dev->opts->alloc_size,
> +               .max_segments           =3D USHRT_MAX,
> +               .max_segment_size       =3D UINT_MAX,
> +       };
>         int err;
>
>         memset(&rbd_dev->tag_set, 0, sizeof(rbd_dev->tag_set));
> @@ -4966,7 +4974,13 @@ static int rbd_init_disk(struct rbd_device *rbd_de=
v)
>         if (err)
>                 return err;
>
> -       disk =3D blk_mq_alloc_disk(&rbd_dev->tag_set, NULL, rbd_dev);
> +       if (rbd_dev->opts->trim) {
> +               lim.discard_granularity =3D rbd_dev->opts->alloc_size;
> +               lim.max_hw_discard_sectors =3D objset_bytes >> SECTOR_SHI=
FT;
> +               lim.max_write_zeroes_sectors =3D objset_bytes >> SECTOR_S=
HIFT;
> +       }
> +
> +       disk =3D blk_mq_alloc_disk(&rbd_dev->tag_set, &lim, rbd_dev);
>         if (IS_ERR(disk)) {
>                 err =3D PTR_ERR(disk);
>                 goto out_tag_set;
> @@ -4987,19 +5001,6 @@ static int rbd_init_disk(struct rbd_device *rbd_de=
v)
>         blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
>         /* QUEUE_FLAG_ADD_RANDOM is off by default for blk-mq */
>
> -       blk_queue_max_hw_sectors(q, objset_bytes >> SECTOR_SHIFT);
> -       q->limits.max_sectors =3D queue_max_hw_sectors(q);
> -       blk_queue_max_segments(q, USHRT_MAX);
> -       blk_queue_max_segment_size(q, UINT_MAX);
> -       blk_queue_io_min(q, rbd_dev->opts->alloc_size);
> -       blk_queue_io_opt(q, rbd_dev->opts->alloc_size);
> -
> -       if (rbd_dev->opts->trim) {
> -               q->limits.discard_granularity =3D rbd_dev->opts->alloc_si=
ze;
> -               blk_queue_max_discard_sectors(q, objset_bytes >> SECTOR_S=
HIFT);
> -               blk_queue_max_write_zeroes_sectors(q, objset_bytes >> SEC=
TOR_SHIFT);
> -       }
> -
>         if (!ceph_test_opt(rbd_dev->rbd_client->client, NOCRC))
>                 blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, q);
>
> --
> 2.39.2
>

Acked-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya

