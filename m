Return-Path: <ceph-devel+bounces-3564-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 50016B4ABCD
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Sep 2025 13:28:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BBD507AF55E
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Sep 2025 11:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C28032142C;
	Tue,  9 Sep 2025 11:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bJn1ukRo"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13643203B2;
	Tue,  9 Sep 2025 11:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757417273; cv=none; b=aaaDYB7KTKJC7vmJY95HeAGs3WjoWcn0H0+rwPxRwGABYfdJUejf7PhGZFw3nT4DNTbFgeWkmH7vGe08CmiyLWjOAAT+ycC+/oao43emJANEXU0kHJRfWfvjg+Seoqt+HmuVvwrYLqj6Aqxpv6q6DUm2yo7/xmU7vsGpaO35M8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757417273; c=relaxed/simple;
	bh=A+spwf9giZNualmJC8d8fBymJLQpsxrX03XtlOMqg6k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VK/8qixxvLWJviJTNjgyeQcM3rwUbliafDawcDcLwruaApi2H5Zrtkrt3/uLc25Ftbf6wF1aa3CP7HO+QuqrH5VjUE0yDXUJGTtE0QKsk+S8RQEYIfI5/IE1BAXb8F5kEBL9KqGnaEbfBJGWgG/WYzHMsSHSMBbQN1n7KjZSOQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bJn1ukRo; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-25634c5ebdeso22983385ad.0;
        Tue, 09 Sep 2025 04:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757417271; x=1758022071; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VS4aMorio+3l9gYgCOIcE22uRBh0zhWFTybVIbMV5C0=;
        b=bJn1ukRo6lx8bsyp/QKra418pX11gXH5oaC41XfPiea+VYqi7PfB5zjo0uFptKcHzK
         yp9bty5nQTG1DUBoOYsIXQGJ45SUgSgIp9UK+/5AeHtMo5EH37NQMyZ7v2+Gms8vUujC
         KDp66Td2LMZJ+xon3xj/u2hbHIYr5Efk/zogFQH12ucQpdKcmTp95NAyXl8CqUnKCB1n
         6oiksoXAbFocMc/KSzhCavXudwKqzVAFs+v2oXVR8apxCFbvPAoGPV6h4rzKv+cddzI+
         Ws7q3YBuHikZWytS2d6Noua5ss8Rl4L0IZbrz+/yNWU8UrGIGVfmwMoNu8xrz3YZXPYI
         Pswg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757417271; x=1758022071;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VS4aMorio+3l9gYgCOIcE22uRBh0zhWFTybVIbMV5C0=;
        b=TwJr/eB8ifrAuyu96OdbbKv/I7Rr303ydzURoBNQwJkeNdSJG+ImAkmFOsuH23KtFI
         1NyibjaWDiS8AC19sFp0BPBBIOSQ2NyNuxYvxzT6dwyd7yG1j3mffLGaIAnguzrtrsF4
         4acyY1Y6PZ27bgjl2T0x6eCg/v/1PaE5j3OW8iWwfUnZyIJkTdagrVGwk3j4ghW61mkx
         qimMC+oT18CYruNWKSU2MnWZv330Gf92T3SE0nY+jFdb1l70DLq1uzBaKN2gDmqShXNE
         D4M8IYH9k6+SfSDMdkh16pOv1OuTHh3JiuY9u2VGLBEU30BK4JlKEodvZC6MzqdYLRsX
         ojZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVk/YWBVVyG3BKMlRCLS0PLe9Hhu8LOJTctabwq6ScZ22d6Ym+h/mJ15zYWBXHeNIdbCpfjfKbh7KXABuQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxryXzqBQDbnPAtt1jLAHhEOiYA3JTx38rMepUzr29t9XPoW3vY
	nTxPMbdG3qq/ByZrWtK78ZTYwOTEKHlUBf20gkODTxEF2dbVNUB/z6jgDUBQJU4vpOlUSfkBABt
	V+OyVTyyO/Tj/zsFUJg4GQJKl8Q/xOkM=
X-Gm-Gg: ASbGncvnie+Mg22gUtrLe6oiKgWDflnVjUv4WSmYhme/eQy/QIz7ftVCwrBWLxGAElq
	/MvfF3OwvGTVR+GKBqU/ll1i6iKxLxCgsagV54rp0MWK+xfwGaYHZezKb28vtt45HLhV438RK6G
	IEnAXxjrLbwvp9IZ51DyozwmZ4+XTqTL9ZnUiW/g75DfH0zg/aZAs7QM/20qn6+j7gobsQOOqln
	UzAmOQ8voQyXDdafA==
X-Google-Smtp-Source: AGHT+IGCo15pHw5bTlF71hUjAxEN80UMU5dmiwy5hCQ6dx98nr1+5mKER/CEy+RvWz01+K0qBI62qEdKodmVbQISfaQ=
X-Received: by 2002:a17:902:f64e:b0:24c:be1f:c1f7 with SMTP id
 d9443c01a7336-25170e4187fmr136972095ad.39.1757417271090; Tue, 09 Sep 2025
 04:27:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904101131.1258532-1-amarkuze@redhat.com>
In-Reply-To: <20250904101131.1258532-1-amarkuze@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 9 Sep 2025 13:27:39 +0200
X-Gm-Features: Ac12FXzdO8eVygYNvnxz24V9EASyaLUfVuSS8A5TvDX8MDjQRRcCoQGvYTSo5uc
Message-ID: <CAOi1vP_mEt00rGSOx6aHiN9=f2OQWCJx7Xzf8BeuVYDSdGdZjg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ceph/mdsc: Move CEPH_CAP_PIN reference when
 r_parent is updated
To: Alex Markuze <amarkuze@redhat.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Slava.Dubeyko@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 12:11=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> =
wrote:
>
> When the parent directory lock is not held, req->r_parent can become stal=
e and is updated to point to the correct inode.
> However, the associated CEPH_CAP_PIN reference was not being adjusted.
> The CEPH_CAP_PIN is a reference on an inode that is tracked for accountin=
g purposes.
> Moving this pin is important to keep the accounting balanced. When the pi=
n was not moved from the old parent to the new one, it created two problems=
:
> The reference on the old, stale parent was never released, causing a refe=
rence leak.
> A reference for the new parent was never acquired, creating the risk of a=
 reference underflow later in ceph_mdsc_release_request().
> This patch corrects the logic by releasing the pin from the old parent an=
d acquiring it for the new parent when r_parent is switched.
> This ensures reference accounting stays balanced.
>
> Signed-off-by: Alex Markuze <amarkuze@redhat.com>
> Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> ---
>  fs/ceph/mds_client.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index ce0c129f4651..4e5926f36e8d 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3053,12 +3053,19 @@ static struct ceph_msg *create_request_message(st=
ruct ceph_mds_session *session,
>          */
>         if (!parent_locked && req->r_parent && path_info1.vino.ino &&
>             ceph_ino(req->r_parent) !=3D path_info1.vino.ino) {
> +               struct inode *old_parent =3D req->r_parent;
>                 struct inode *correct_dir =3D ceph_get_inode(mdsc->fsc->s=
b, path_info1.vino, NULL);
>                 if (!IS_ERR(correct_dir)) {
>                         WARN_ONCE(1, "ceph: r_parent mismatch (had %llx w=
anted %llx) - updating\n",
> -                                 ceph_ino(req->r_parent), path_info1.vin=
o.ino);
> -                       iput(req->r_parent);
> +                                 ceph_ino(old_parent), path_info1.vino.i=
no);
> +                       /*
> +                        * Transfer CEPH_CAP_PIN from the old parent to t=
he new one.
> +                        * The pin was taken earlier in ceph_mdsc_submit_=
request().
> +                        */
> +                       ceph_put_cap_refs(ceph_inode(old_parent), CEPH_CA=
P_PIN);
> +                       iput(old_parent);
>                         req->r_parent =3D correct_dir;
> +                       ceph_get_cap_refs(ceph_inode(req->r_parent), CEPH=
_CAP_PIN);
>                 }
>         }
>
> --
> 2.34.1
>

Folded into "ceph: fix client race condition validating r_parent before
applying state" and queued up for 6.17-rc6.

Thanks,

                Ilya

