Return-Path: <ceph-devel+bounces-65-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 928E77E3897
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Nov 2023 11:14:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F6ADB20BFB
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Nov 2023 10:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ADFC12E6C;
	Tue,  7 Nov 2023 10:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N7wJaEcs"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CC212E67
	for <ceph-devel@vger.kernel.org>; Tue,  7 Nov 2023 10:14:41 +0000 (UTC)
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139C5F7
	for <ceph-devel@vger.kernel.org>; Tue,  7 Nov 2023 02:14:40 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id 006d021491bc7-5872c6529e1so3233969eaf.0
        for <ceph-devel@vger.kernel.org>; Tue, 07 Nov 2023 02:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699352079; x=1699956879; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tRS0YN1PgZRFOf3Nd7qbTxu3wLUszdYltfBZax54x0o=;
        b=N7wJaEcsx+l4G0PMctfNHmtf+MxubxMaQI0v31jLnp5MPZIMHhvzaxcT1HgUpwtgZ/
         EVJWbks4uem5qMLV01w1UOohjH5AQrprRsRrkY7EZ6I7VyjQo1nWPO7dAV4ZzfAlTalH
         eIV148Bd+3klI6Y3v7SHKbqDWzfU9GJj8N1ep/RiHneYYv4HH8eWFQ/2HPiiZ9LVAB7u
         GvAJHGyGJgeQ+8vsnvaBPQtWHPfrpakA1V+yj5qGbti29RyoyoCQr60Vt5UPiQh2Jth2
         X+epT4fbxf4drb1KzkIOQ52ujVAvkWeY5bSe09cQYI0iBGs/mE9hlRpyVWg/tR3hC014
         yCaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699352079; x=1699956879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tRS0YN1PgZRFOf3Nd7qbTxu3wLUszdYltfBZax54x0o=;
        b=F2rgYJIQuMBm6PNPlWuSpYrlOH3axH3flIPMx/u6FquP8sRoff0DptsllhgNdgruA5
         YQfgsLiTaVSOYNQx8LTsRszg5cQ18nRte3xYDTxSjRkbVpV+RuKACQTGhlQCjczqke2/
         wz7wivOSAben5NB9sIY1akpFEllX427aNX8x3Lwe0dkBNCIhOve3K5REAI9Wocv6JorD
         TF/+34mZjOT8//y/F58TiA2SCjtASX/jHnWgmVLHCVMieVuIR8xbX2ZzVfQ68mN2kbR4
         fkP3QyzzmITGmOzTi28NsskucQF5sP81TjXl7MWadmYEx5HJZUeNRy5mXCmL8Qtd5xt4
         XqwQ==
X-Gm-Message-State: AOJu0YyMgTCbKyoWx7dw3yyVCX8+CBvQpKfd8hSzLvf3y0+3tO/z0dG2
	eSuN5Z0strvnLc/PYMOdaZb8Gq8Lh3IM/5PcP2I=
X-Google-Smtp-Source: AGHT+IHkox8uts8Kmmp+mUtl2eOcweBitByo8uq5vGUgU5Sf8sHA0c38WfxL6n0r1Y1hhLuD2/n6uQFo/mLl8UuCd48=
X-Received: by 2002:a05:6820:3d3:b0:586:a887:4633 with SMTP id
 s19-20020a05682003d300b00586a8874633mr24936158ooj.5.1699352079264; Tue, 07
 Nov 2023 02:14:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231107014458.299637-1-xiubli@redhat.com>
In-Reply-To: <20231107014458.299637-1-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 7 Nov 2023 11:14:27 +0100
Message-ID: <CAOi1vP9J8JWFRpVEoojgH_LOdJm+dvvQO-EzyhPAW55kQ0k_vw@mail.gmail.com>
Subject: Re: [PATCH v3] libceph: remove the max extents check for sparse read
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 2:47=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> There is no any limit for the extent array size and it's possible
> that when reading with a large size contents the total number of
> extents will exceed 4096. Then the messager will fail by reseting
> the connection and keeps resending the inflight IOs infinitely.
>
> URL: https://tracker.ceph.com/issues/62081
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V3:
> - Remove the max extents check and add one debug log.
>
> V2:
> - Increase the MAX_EXTENTS instead of removing it.
> - Do not return an errno when hit the limit.
>
>
>
>
>  net/ceph/osd_client.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
>
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index c03d48bd3aff..5f10ab76d0f3 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5850,8 +5850,6 @@ static inline void convert_extent_map(struct ceph_s=
parse_read *sr)
>  }
>  #endif
>
> -#define MAX_EXTENTS 4096
> -
>  static int osd_sparse_read(struct ceph_connection *con,
>                            struct ceph_msg_data_cursor *cursor,
>                            char **pbuf)
> @@ -5882,23 +5880,16 @@ static int osd_sparse_read(struct ceph_connection=
 *con,
>
>                 if (count > 0) {
>                         if (!sr->sr_extent || count > sr->sr_ext_len) {
> -                               /*
> -                                * Apply a hard cap to the number of exte=
nts.
> -                                * If we have more, assume something is w=
rong.
> -                                */
> -                               if (count > MAX_EXTENTS) {
> -                                       dout("%s: OSD returned 0x%x exten=
ts in a single reply!\n",
> -                                            __func__, count);
> -                                       return -EREMOTEIO;
> -                               }
> -
>                                 /* no extent array provided, or too short=
 */
>                                 kfree(sr->sr_extent);
>                                 sr->sr_extent =3D kmalloc_array(count,
>                                                               sizeof(*sr-=
>sr_extent),
>                                                               GFP_NOIO);
> -                               if (!sr->sr_extent)
> +                               if (!sr->sr_extent) {
> +                                       pr_err("%s: failed to allocate %u=
 sparse read extents\n",
> +                                              __func__, count);

Hi Xiubo,

No need to include the function name: a) this is an error message as
opposed to a debug message and b) such allocation is done only in one
place anyway.

Otherwise LGTM!

Thanks,

                Ilya

