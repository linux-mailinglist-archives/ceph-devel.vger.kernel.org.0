Return-Path: <ceph-devel+bounces-871-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2451F8576FC
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Feb 2024 08:49:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 495CB1C21C5A
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Feb 2024 07:49:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C44175BE;
	Fri, 16 Feb 2024 07:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="MYeVffNE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97D415E96
	for <ceph-devel@vger.kernel.org>; Fri, 16 Feb 2024 07:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708069786; cv=none; b=koBBDwwCx4gP17QOtPqoc/QvjY+JMPxyiVM5J/FjxKBYrScex0kpy0QzPfU+3XpSX6kuzZhkyf2+p6RAgYGUBhzSHkCdYs1+W5umzJWcqgzLNIfWM/NI5I/67/KOqrhq/fwIQzmt4Y0eSkFqLtbwcxMcuLFZSSgSaEIDl//YQkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708069786; c=relaxed/simple;
	bh=V2EdJjvqxAqCtw18lO2fEH+iEeksTk/mBimlO53/O40=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nECvaOZ+ocBI6b6gB+s2QJxuWYRhXaAHk5IjZ2XQfbQF5pZ4zSym3d23s5b8nVom8u0Hnwq/vsbvhSLyV8b9zb3YZyDD8Hw79VreNSFJZnGIj3OCij7EKqo+8LgXsARWAIugZ66blrvssssHvx5vAUs9bRQ71kGXy8Oz/+MpWj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=MYeVffNE; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5639c8cc449so508682a12.2
        for <ceph-devel@vger.kernel.org>; Thu, 15 Feb 2024 23:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1708069782; x=1708674582; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FKtrR0GptUvN+scEUpBPwjTH5qrhKCgtCeXIuRBm1rE=;
        b=MYeVffNEmZUTahVi/A4kJeB/m1pFJlznUyhAFsFFTT5b3esiD5FrC0EuBHJX4QvWC1
         KER7CWomH96ZhR3MwL5pZhZ5w+iv51BNlP44YJ+LsFRY+MOcsDG93lGCieDX0BsmX7hk
         1eVrAXEWh+/bx1SZ4E2l61VXyvBBfDXLm3VfWpSg23XQjwpHqbhcd2iKWdDsshoKIuSF
         8pbfeKkfasgl78V7yN71gUlLlwaBG2nfG3LsS0fKTj4s0+N1I5Z477pTdvbBcnFBYpJD
         O8TpvrEOMZlpnK+WV/mXfz5uOfVFs6IqHSJqQZd55NVhu14JcDxy/0jl2B46EPtF2v5t
         VjCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708069782; x=1708674582;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FKtrR0GptUvN+scEUpBPwjTH5qrhKCgtCeXIuRBm1rE=;
        b=Cyjn7C1O8mYQTCmNSIvkX+/M5AAMuqQoTizhCxuklMV+lF27zMbaLNus/3OaN6o4aJ
         p4S4Ao6wEHo+lxJkRLMNJHaGLTWDH0M7qvEB1Zk1s0L0sN+Q9pNv1jBtABHmBKbn26Iu
         mkiz6q9eHsQq/5ji/LCZKHLwXWhAx76fczrj5iadmLTmGUBE2nBm2kwPLcorDuwExqjq
         jPW9NxLBzIdMPWOeQHcLO7j2KZIRZbg16T8r34Wepq6P7+7A2PFl4ZoLq7bwmOzcmfua
         r8+cIM5Y5CxOidGvpy2U+PuHpJMT9YipCssyDhrk+vQx3LBPjU1K6MVDnR/fO+XVRTHx
         j/Pg==
X-Forwarded-Encrypted: i=1; AJvYcCWMA1Bx+1amPY5m4ZKj+EWr2HtbhbhmJghZLdwL+p4jZBqAhLHw1YkR+r5kLzapJgHtExIB50SbF66c7SnDp43JxxQCW+PTUBcrmg==
X-Gm-Message-State: AOJu0Yzqi/hfk6q/D0q+iLIKzosP+sBl2TBq/2Lc9fwqm7M22hrpXo/s
	tjtMzXvMUEg0qyt+2XgiP5otWTYs5wcZFzBRRurcNp27oD3Sp7QzPvNyCfhpufnorptAWZZ+V77
	GpevOZJLKK7LQjugTJERpDPr7gs9Yylwyb3fhvQ==
X-Google-Smtp-Source: AGHT+IEz+DOqbldxdx8VWXCWP6/6fTdJY+pnjm4uq4NWwzDh2gUwnQ0y3y2rNodnC/dPtB2uhZ02GJwHr8oI/OyBPSQ=
X-Received: by 2002:a05:6402:3593:b0:563:fc1d:4568 with SMTP id
 y19-20020a056402359300b00563fc1d4568mr440920edc.10.1708069782007; Thu, 15 Feb
 2024 23:49:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215070300.2200308-1-hch@lst.de> <20240215070300.2200308-9-hch@lst.de>
In-Reply-To: <20240215070300.2200308-9-hch@lst.de>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Fri, 16 Feb 2024 08:49:30 +0100
Message-ID: <CAMGffE=cpyWvxWwdmhyxhgBr7zxvqHS2BQwx-zm2=cm3VjRFxQ@mail.gmail.com>
Subject: Re: [PATCH 08/17] rnbd-clt: pass queue_limits to blk_mq_alloc_disk
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Justin Sanders <justin@coraid.com>, Denis Efremov <efremov@linux.com>, 
	Josef Bacik <josef@toxicpanda.com>, Geoff Levand <geoff@infradead.org>, 
	Ilya Dryomov <idryomov@gmail.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
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
> Pass the limits rnbd-clt imposes directly to blk_mq_alloc_disk instead
> of setting them one at a time.
>
> While at it don't set an explicit number of discard segments, as 1 is
> the default (which most drivers rely on).
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
lgtm, thx!
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/block/rnbd/rnbd-clt.c | 64 ++++++++++++++---------------------
>  1 file changed, 25 insertions(+), 39 deletions(-)
>
> diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.=
c
> index d51be4f2df61a3..b7ffe03c61606d 100644
> --- a/drivers/block/rnbd/rnbd-clt.c
> +++ b/drivers/block/rnbd/rnbd-clt.c
> @@ -1329,43 +1329,6 @@ static void rnbd_init_mq_hw_queues(struct rnbd_clt=
_dev *dev)
>         }
>  }
>
> -static void setup_request_queue(struct rnbd_clt_dev *dev,
> -                               struct rnbd_msg_open_rsp *rsp)
> -{
> -       blk_queue_logical_block_size(dev->queue,
> -                                    le16_to_cpu(rsp->logical_block_size)=
);
> -       blk_queue_physical_block_size(dev->queue,
> -                                     le16_to_cpu(rsp->physical_block_siz=
e));
> -       blk_queue_max_hw_sectors(dev->queue,
> -                                dev->sess->max_io_size / SECTOR_SIZE);
> -
> -       /*
> -        * we don't support discards to "discontiguous" segments
> -        * in on request
> -        */
> -       blk_queue_max_discard_segments(dev->queue, 1);
> -
> -       blk_queue_max_discard_sectors(dev->queue,
> -                                     le32_to_cpu(rsp->max_discard_sector=
s));
> -       dev->queue->limits.discard_granularity =3D
> -                                       le32_to_cpu(rsp->discard_granular=
ity);
> -       dev->queue->limits.discard_alignment =3D
> -                                       le32_to_cpu(rsp->discard_alignmen=
t);
> -       if (le16_to_cpu(rsp->secure_discard))
> -               blk_queue_max_secure_erase_sectors(dev->queue,
> -                                       le32_to_cpu(rsp->max_discard_sect=
ors));
> -       blk_queue_flag_set(QUEUE_FLAG_SAME_COMP, dev->queue);
> -       blk_queue_flag_set(QUEUE_FLAG_SAME_FORCE, dev->queue);
> -       blk_queue_max_segments(dev->queue, dev->sess->max_segments);
> -       blk_queue_io_opt(dev->queue, dev->sess->max_io_size);
> -       blk_queue_virt_boundary(dev->queue, SZ_4K - 1);
> -       blk_queue_write_cache(dev->queue,
> -                             !!(rsp->cache_policy & RNBD_WRITEBACK),
> -                             !!(rsp->cache_policy & RNBD_FUA));
> -       blk_queue_max_write_zeroes_sectors(dev->queue,
> -                                          le32_to_cpu(rsp->max_write_zer=
oes_sectors));
> -}
> -
>  static int rnbd_clt_setup_gen_disk(struct rnbd_clt_dev *dev,
>                                    struct rnbd_msg_open_rsp *rsp, int idx=
)
>  {
> @@ -1403,18 +1366,41 @@ static int rnbd_clt_setup_gen_disk(struct rnbd_cl=
t_dev *dev,
>  static int rnbd_client_setup_device(struct rnbd_clt_dev *dev,
>                                     struct rnbd_msg_open_rsp *rsp)
>  {
> +       struct queue_limits lim =3D {
> +               .logical_block_size     =3D le16_to_cpu(rsp->logical_bloc=
k_size),
> +               .physical_block_size    =3D le16_to_cpu(rsp->physical_blo=
ck_size),
> +               .io_opt                 =3D dev->sess->max_io_size,
> +               .max_hw_sectors         =3D dev->sess->max_io_size / SECT=
OR_SIZE,
> +               .max_hw_discard_sectors =3D le32_to_cpu(rsp->max_discard_=
sectors),
> +               .discard_granularity    =3D le32_to_cpu(rsp->discard_gran=
ularity),
> +               .discard_alignment      =3D le32_to_cpu(rsp->discard_alig=
nment),
> +               .max_segments           =3D dev->sess->max_segments,
> +               .virt_boundary_mask     =3D SZ_4K - 1,
> +               .max_write_zeroes_sectors =3D
> +                       le32_to_cpu(rsp->max_write_zeroes_sectors),
> +       };
>         int idx =3D dev->clt_device_id;
>
>         dev->size =3D le64_to_cpu(rsp->nsectors) *
>                         le16_to_cpu(rsp->logical_block_size);
>
> -       dev->gd =3D blk_mq_alloc_disk(&dev->sess->tag_set, NULL, dev);
> +       if (rsp->secure_discard) {
> +               lim.max_secure_erase_sectors =3D
> +                       le32_to_cpu(rsp->max_discard_sectors);
> +       }
> +
> +       dev->gd =3D blk_mq_alloc_disk(&dev->sess->tag_set, &lim, dev);
>         if (IS_ERR(dev->gd))
>                 return PTR_ERR(dev->gd);
>         dev->queue =3D dev->gd->queue;
>         rnbd_init_mq_hw_queues(dev);
>
> -       setup_request_queue(dev, rsp);
> +       blk_queue_flag_set(QUEUE_FLAG_SAME_COMP, dev->queue);
> +       blk_queue_flag_set(QUEUE_FLAG_SAME_FORCE, dev->queue);
> +       blk_queue_write_cache(dev->queue,
> +                             !!(rsp->cache_policy & RNBD_WRITEBACK),
> +                             !!(rsp->cache_policy & RNBD_FUA));
> +
>         return rnbd_clt_setup_gen_disk(dev, rsp, idx);
>  }
>
> --
> 2.39.2
>

