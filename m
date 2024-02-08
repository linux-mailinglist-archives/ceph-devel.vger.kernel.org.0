Return-Path: <ceph-devel+bounces-838-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41BC584DA54
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Feb 2024 07:47:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABC0F1F21A03
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Feb 2024 06:47:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9739B67C70;
	Thu,  8 Feb 2024 06:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sr3taV0X"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B9B692F2
	for <ceph-devel@vger.kernel.org>; Thu,  8 Feb 2024 06:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707374848; cv=none; b=FFC5r4joBHw4l7Mo4ZDiLd17I2kqWF+QnN2QIxOGzuEniNHwEvaW3MJnmznnOLf4GhPRoKTc9jAZkC2mjWnYFHGTGDVIkmj3GKCrHEA3IMEONm5h7PWa/v0S6H5smqZEVW7obErEHcIxBxfyoaa8euM6atjXDs/DJnOl2hmr/fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707374848; c=relaxed/simple;
	bh=M5y5+e2O6skt1ZwNKmTau9qOQ2OW/xvRgw4ntIniXpY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BwpKPXihoOOS0GDy4Tsi7Ro4fbmIr97TFVNbBaxFMfskMtZGJp3B+TRswvC+imP6VbOfcAO7t2gsxBUcEhxzkcm0ceof67LnO+14TdROgKRBUHne3sBw9YoPhcwMR+dgHIwf4gzIcSkrFMSRdZt0EHVId3+K5kPuv1qhTntpO7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sr3taV0X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707374844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lF0YcezM9M/Tbc6+2NBTjjXolhiV1/+hEVh7x7+h7tI=;
	b=Sr3taV0XqgcIvLjcE1GJt/8pzT4Cckrws6GdmiJUN4ESWC9wl2DUosxD+OwT3/ccuhF79U
	NgLNoC7D9K2/Ca+I1Qu35qmD5qVmcHl7WhWrjRsaRttVxj4OgWnyzSRxT0ucZLCoqSu0BA
	slyoeOI8Xaps6VjzyVWbd2H/boCh4wQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-sPXe_dl-Peqpv8xQGgHRXA-1; Thu, 08 Feb 2024 01:47:22 -0500
X-MC-Unique: sPXe_dl-Peqpv8xQGgHRXA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a2f71c83b7eso105591266b.1
        for <ceph-devel@vger.kernel.org>; Wed, 07 Feb 2024 22:47:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707374842; x=1707979642;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lF0YcezM9M/Tbc6+2NBTjjXolhiV1/+hEVh7x7+h7tI=;
        b=ELbCM1fuk4VmiRnQOi7MPrjaVussugje7eGwbSFlYHStBs54lH/6aYUyxGUCtDOfEX
         k0zzrJF1iSrRQAJTQyMJ/46jk+weB/T0R+OKPH7nsOyec87V5UZMctTbNF6M2e1n1FIx
         nISzN6qA54GESFY6nScm3USl/CfJ8Yyh7DaTUMLBs559aUqEKdDXcv3JYFqRRruk7gIN
         l+lGqWx2txaz70pe21ft1+NgtrdgtnE9rGBw9k2rntWY94v7u4RtCjHXgPDKJjayekcm
         D0Slom9nE9y3reK9mDm8BnbFOkwaKbSVLI2FQ+kMJv1PiyLCrewV1sIYunGhea43lHP3
         bioA==
X-Gm-Message-State: AOJu0YzHiwW0EjKqoeNzml9rc/HGbnLcmH5GadPZme9mL7P1BQqst2e6
	D0PSjjedWXEdMox9OG9m7qAxSNBOG7sgYRKeu8sLru9OfpsWWm7BMJxziVM6Inf/GJsU0Qab2Tr
	UPmDUPC4oEUpSO8E9IC+ny7VHbgxFc/szXj0v1Nn+Q0H6UTIedB1Rb6HDQs/Kv+tTfROhtcqeV+
	6x233ajJUUaXYu6fgVpbP5wklWRkvUDifF2A==
X-Received: by 2002:a17:906:3ca1:b0:a38:5ae:9c97 with SMTP id b1-20020a1709063ca100b00a3805ae9c97mr4824449ejh.40.1707374841763;
        Wed, 07 Feb 2024 22:47:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGNnDvZSoki2Y3hqmd6TWzawg9jtOFZoE6SNv49VThaT/eO4/hNbfxe/rtHGJS/geOdmDBeTsGhT11v5gZ1HOc=
X-Received: by 2002:a17:906:3ca1:b0:a38:5ae:9c97 with SMTP id
 b1-20020a1709063ca100b00a3805ae9c97mr4824432ejh.40.1707374841315; Wed, 07 Feb
 2024 22:47:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240104041723.1120866-1-xiubli@redhat.com>
In-Reply-To: <20240104041723.1120866-1-xiubli@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Thu, 8 Feb 2024 12:16:44 +0530
Message-ID: <CACPzV1=6ZOsbEkVffDUzQQbz_hPVFLUzauJHoeeXiFvqOt98EQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: always check dir caps asynchronously
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 4, 2024 at 9:49=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The MDS will issue the 'Fr' caps for async dirop, while there is
> buggy in kclient and it could miss releasing the async dirop caps,
> which is 'Fsxr'. And then the MDS will complain with:
>
> "[WRN] client.xxx isn't responding to mclientcaps(revoke) ..."
>
> So when releasing the dirop async requests or when they fail we
> should always make sure that being revoked caps could be released.
>
> URL: https://tracker.ceph.com/issues/50223
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c       | 6 ------
>  fs/ceph/mds_client.c | 9 ++++-----
>  fs/ceph/mds_client.h | 2 +-
>  fs/ceph/super.h      | 2 --
>  4 files changed, 5 insertions(+), 14 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index a9e19f1f26e0..4dd92f09b16e 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3216,7 +3216,6 @@ static int ceph_try_drop_cap_snap(struct ceph_inode=
_info *ci,
>
>  enum put_cap_refs_mode {
>         PUT_CAP_REFS_SYNC =3D 0,
> -       PUT_CAP_REFS_NO_CHECK,
>         PUT_CAP_REFS_ASYNC,
>  };
>
> @@ -3332,11 +3331,6 @@ void ceph_put_cap_refs_async(struct ceph_inode_inf=
o *ci, int had)
>         __ceph_put_cap_refs(ci, had, PUT_CAP_REFS_ASYNC);
>  }
>
> -void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci, int had=
)
> -{
> -       __ceph_put_cap_refs(ci, had, PUT_CAP_REFS_NO_CHECK);
> -}
> -
>  /*
>   * Release @nr WRBUFFER refs on dirty pages for the given @snapc snap
>   * context.  Adjust per-snap dirty page accounting as appropriate.
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 7bdee08ec2eb..f278194a1a01 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1089,7 +1089,7 @@ void ceph_mdsc_release_request(struct kref *kref)
>         struct ceph_mds_request *req =3D container_of(kref,
>                                                     struct ceph_mds_reque=
st,
>                                                     r_kref);
> -       ceph_mdsc_release_dir_caps_no_check(req);
> +       ceph_mdsc_release_dir_caps_async(req);
>         destroy_reply_info(&req->r_reply_info);
>         if (req->r_request)
>                 ceph_msg_put(req->r_request);
> @@ -4428,7 +4428,7 @@ void ceph_mdsc_release_dir_caps(struct ceph_mds_req=
uest *req)
>         }
>  }
>
> -void ceph_mdsc_release_dir_caps_no_check(struct ceph_mds_request *req)
> +void ceph_mdsc_release_dir_caps_async(struct ceph_mds_request *req)
>  {
>         struct ceph_client *cl =3D req->r_mdsc->fsc->client;
>         int dcaps;
> @@ -4436,8 +4436,7 @@ void ceph_mdsc_release_dir_caps_no_check(struct cep=
h_mds_request *req)
>         dcaps =3D xchg(&req->r_dir_caps, 0);
>         if (dcaps) {
>                 doutc(cl, "releasing r_dir_caps=3D%s\n", ceph_cap_string(=
dcaps));
> -               ceph_put_cap_refs_no_check_caps(ceph_inode(req->r_parent)=
,
> -                                               dcaps);
> +               ceph_put_cap_refs_async(ceph_inode(req->r_parent), dcaps)=
;
>         }
>  }
>
> @@ -4473,7 +4472,7 @@ static void replay_unsafe_requests(struct ceph_mds_=
client *mdsc,
>                 if (req->r_session->s_mds !=3D session->s_mds)
>                         continue;
>
> -               ceph_mdsc_release_dir_caps_no_check(req);
> +               ceph_mdsc_release_dir_caps_async(req);
>
>                 __send_request(session, req, true);
>         }
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index e85172a92e6c..92695a280d7b 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -579,7 +579,7 @@ extern int ceph_mdsc_do_request(struct ceph_mds_clien=
t *mdsc,
>                                 struct inode *dir,
>                                 struct ceph_mds_request *req);
>  extern void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req);
> -extern void ceph_mdsc_release_dir_caps_no_check(struct ceph_mds_request =
*req);
> +extern void ceph_mdsc_release_dir_caps_async(struct ceph_mds_request *re=
q);
>  static inline void ceph_mdsc_get_request(struct ceph_mds_request *req)
>  {
>         kref_get(&req->r_kref);
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index f418b43d0e05..8832da060253 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1258,8 +1258,6 @@ extern void ceph_take_cap_refs(struct ceph_inode_in=
fo *ci, int caps,
>  extern void ceph_get_cap_refs(struct ceph_inode_info *ci, int caps);
>  extern void ceph_put_cap_refs(struct ceph_inode_info *ci, int had);
>  extern void ceph_put_cap_refs_async(struct ceph_inode_info *ci, int had)=
;
> -extern void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci,
> -                                           int had);
>  extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int n=
r,
>                                        struct ceph_snap_context *snapc);
>  extern void __ceph_remove_capsnap(struct inode *inode,
> --
> 2.43.0
>

Tested-by: Venky Shankar <vshankar@redhat.com>

--=20
Cheers,
Venky


