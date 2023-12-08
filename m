Return-Path: <ceph-devel+bounces-268-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DB3880A760
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 16:28:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A79D1C208F4
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 15:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD3D830656;
	Fri,  8 Dec 2023 15:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oljrke00"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AE310C0
	for <ceph-devel@vger.kernel.org>; Fri,  8 Dec 2023 07:28:44 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id 006d021491bc7-59064bca27dso1098439eaf.0
        for <ceph-devel@vger.kernel.org>; Fri, 08 Dec 2023 07:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702049323; x=1702654123; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMPk7thvXXNa1AXK9MSwbR+VeYj1hkKG6J8jhA1Eb2g=;
        b=Oljrke00tN1S3TImORoB9YUKlcTKoVpw5JoV78Pz40TrV3xBV+yaMYDv39sAoZdMRY
         90R1VX0C9uqfiel1Oe+CiDymznlXB1VE5ZgCQnLA8XANHkyyfnM29fW9iviofXcVIqRF
         5WmN/e6Crh9/kO2WD2qlIj7OwsocI1icZUmpiiyOxD6RC1gcCaEa/8SNs78eO71wzDME
         HpRIY+1Q/3PE/AJjZ1ZX+Nnj8TDKw9yFDQOp2hWOIhZb/oJB23TSkPywWLiZJElejDF6
         LW+sm5DxB/O2jPxmkJhDIIaaRXITg8xpdLUsrLvo/s0CSYHjeMykSs+5HuT5rFp9Dhyy
         g7pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702049323; x=1702654123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tMPk7thvXXNa1AXK9MSwbR+VeYj1hkKG6J8jhA1Eb2g=;
        b=MbGTfjP+l5K9XzmcWnSkoDNIDA9Zc4/eLVgmgFeyLH6h3oQ3Z1HlrkSJd1eBkvfbKD
         ZD8sCkmPVhXRXZGqACs64/+/5ydHdkVZXLakpSz8Vw/95hbW5TriapkE9bqDMwxVArf/
         Z7CSnvDSwBxuxAD8dWZ6LxeUmpTTo69RF6UURr/693FsU0Axbhl/W4E8CckWlkf7d8dM
         MSQbz11UfXBmh1GiICrXz2+ENDohs/MOOKGfJPM8sSDiU4FAqefRY9TyfdRPXMbej0ZY
         MH1qsQQy4PBFf/f5KiUkHPBcLq2HkwcFX75Ckf+cQDqyZHjSAajkxrEnmZ289kMy/MOV
         Ge7A==
X-Gm-Message-State: AOJu0Yy8ciPiXa+Im5jQFVS7jJ/OG2jG5LVpdm0uh25z2iEXGkkUnLGA
	OY1WMS0ChVXruqpGLQRAEQT40R8s6iupmHripH9ViukMUAo=
X-Google-Smtp-Source: AGHT+IExdcaFdZsc2ObvGnA7FUuY4J4qZcGbQR3gnfG3FE9JVzwRPM9Xt3Me2tgIbh5+wGZ5uhUyeNXs1rw5OD7Ch/c=
X-Received: by 2002:a05:6820:1ad6:b0:590:8496:b5d1 with SMTP id
 bu22-20020a0568201ad600b005908496b5d1mr290585oob.2.1702049322407; Fri, 08 Dec
 2023 07:28:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231208043305.91249-1-xiubli@redhat.com> <20231208043305.91249-2-xiubli@redhat.com>
 <CAOi1vP-aL0viMVHjXQr_CA0MyKNQ8FWH1qF4Vh-ntjFrOqYMNA@mail.gmail.com> <45aa72ee-4561-4159-ad52-055ae29da1f1@redhat.com>
In-Reply-To: <45aa72ee-4561-4159-ad52-055ae29da1f1@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 8 Dec 2023 16:28:30 +0100
Message-ID: <CAOi1vP_AArSuq7h0EhKC_K3cs+nbrzzypPcqyyQU+Tk0Gu3y2Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] libceph: fail the sparse-read if there still has data
 in socket
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 8, 2023 at 4:18=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 12/8/23 19:31, Ilya Dryomov wrote:
>
> On Fri, Dec 8, 2023 at 5:34=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Once this happens that means there have bugs.
>
> URL: https://tracker.ceph.com/issues/63586
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  net/ceph/osd_client.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 5753036d1957..848ef19055a0 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5912,10 +5912,12 @@ static int osd_sparse_read(struct ceph_connection=
 *con,
>                 fallthrough;
>         case CEPH_SPARSE_READ_DATA:
>                 if (sr->sr_index >=3D count) {
> -                       if (sr->sr_datalen && count)
> +                       if (sr->sr_datalen) {
>                                 pr_warn_ratelimited("sr_datalen %u sr_ind=
ex %d count %u\n",
>                                                     sr->sr_datalen, sr->s=
r_index,
>                                                     count);
> +                               return -EREMOTEIO;
> +                       }
>
>                         sr->sr_state =3D CEPH_SPARSE_READ_HDR;
>                         goto next_op;
> --
> 2.43.0
>
> Hi Xiubo,
>
> There is a patch in linux-next, also from you, which is conflicting
> with this one: cca19d307d35 ("libceph: check the data length when
> sparse read finishes").  Do you want it replaced?
>
> Ilya,
>
> I found the commit cca19d307d35 has already in the master branch. Could y=
ou fold and update it ?

I would like to see the entire fix first.  You seem to be going back
and forth between just issuing a warning or also returning an error and
the precise if condition there, so I'm starting to think that the bug
is not fully understood and neither patch might be necessary.

Thanks,

                Ilya

