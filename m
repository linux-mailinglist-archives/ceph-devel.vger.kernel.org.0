Return-Path: <ceph-devel+bounces-529-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CE6B82E966
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jan 2024 07:03:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD565B226E4
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jan 2024 06:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D93E5134DF;
	Tue, 16 Jan 2024 06:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HA96MowV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC79134D9
	for <ceph-devel@vger.kernel.org>; Tue, 16 Jan 2024 06:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705384985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HNIFIBX3rsjA4UvAWg68N+X5wGzA8xsA1jGnp4p1Y3c=;
	b=HA96MowVwISeHRSSQ0em3aZ847rfeBHgBpBy6mUambirjoKi7HXg1Lle3KGXxarmNp9LTr
	iAzR14HPHXQYWAPja655sJuG5KGfouGZr2PBcitxGLJVgafKOR5iE08K6KgkFZnPkarpRg
	F2zdjwbdZrVTTH42fC8ez6Cm+oD5/X0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-JgdJW07FPfqJbCsZ_B1pSg-1; Tue, 16 Jan 2024 01:03:03 -0500
X-MC-Unique: JgdJW07FPfqJbCsZ_B1pSg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a2bffe437b5so306441766b.1
        for <ceph-devel@vger.kernel.org>; Mon, 15 Jan 2024 22:03:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705384982; x=1705989782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HNIFIBX3rsjA4UvAWg68N+X5wGzA8xsA1jGnp4p1Y3c=;
        b=J3ykjC6C/uUNZUsjDq2x0UBYfbp2lY1hnY38TtjDwuCLACpYKD6sdGYlzI6HXPI5uL
         cASaE7hyNqDxJoabQWtTYbgieJWhr5lpktsWSFykPfaK+SS6JTMq9TQlIhmC0G3RGnSJ
         17/v5Ouyz6Mjw+um8BlJs1ELR5w+E3lUeIS/cdrYCTacPX90JlwqENQyYLLPy5pNu4K+
         GweoDF8m9OTBzK+/WF0UhlKw5VWeRvy21vVG9GbwNKxKK5YfEmwmD/nRxmOoMbAvHu6s
         yH+iRfr1RcDbzl1Usr4VJLxr2+QiaAfyp0JhDNUDHPGpHpSa8JgjZF+MJPxad1M/rdlG
         /CTg==
X-Gm-Message-State: AOJu0YwcTG9eV8AUwYDCD3A4dwRGvid57HXenL/gIOvtQgodbwQMq03M
	3Mj/fuVEA4Y+yZhoX1BMZ53s5OGy27D8V3feXZrNSlmF3S1h9M2sVyXlqHtXK8CPy8h99ql2jfN
	rw0YJx5cdunNJr0ZwolrLgB+B4vyla9u9L6J9HtIZ0Yu0Zg==
X-Received: by 2002:a17:907:36c8:b0:a27:6615:1653 with SMTP id bj8-20020a17090736c800b00a2766151653mr4093912ejc.34.1705384982554;
        Mon, 15 Jan 2024 22:03:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEnBPAtI8f1QH7G2pAT1e5IS2+caImjWVdJBiqkM1lq1v5pBR85hpUWcnaxSrh9OVKm1X4Pxgp2DZQvuMER2Uo=
X-Received: by 2002:a17:907:36c8:b0:a27:6615:1653 with SMTP id
 bj8-20020a17090736c800b00a2766151653mr4093909ejc.34.1705384982229; Mon, 15
 Jan 2024 22:03:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240104041723.1120866-1-xiubli@redhat.com>
In-Reply-To: <20240104041723.1120866-1-xiubli@redhat.com>
From: Milind Changire <mchangir@redhat.com>
Date: Tue, 16 Jan 2024 11:32:26 +0530
Message-ID: <CAED=hWAqrXxr9aDzpytvruKTX9dojVj0cCW58boUuz_7hVnT9g@mail.gmail.com>
Subject: Re: [PATCH] ceph: always check dir caps asynchronously
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org, 
	vshankar@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Approved.

Reviewed-by: Milind Changire <mchangir@redhat.com>

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


--=20
Milind


