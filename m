Return-Path: <ceph-devel+bounces-909-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 271D9867FDC
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Feb 2024 19:32:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61B561C23DBF
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Feb 2024 18:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F8D81E53A;
	Mon, 26 Feb 2024 18:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S3odkv75"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8420A1DFF7
	for <ceph-devel@vger.kernel.org>; Mon, 26 Feb 2024 18:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708972336; cv=none; b=X3yGTtwsdGoZsXgvcW1S5YyVdqJDux2t7xr01oQvXhpcgnRm/4RP+IJRNAN3VCUhTYVMTX2CqjKwoa+1BOYbkLWFkGKkzYAgzb3mlNald2cXN1MFNG+tlA4hgqgw7gdPULN1RSu8OkzvipdnepcvjjQHk3uiuUjwQ+n1RZW+muk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708972336; c=relaxed/simple;
	bh=IJTf1sJ/QWejFTNhNnEkVN+tD8MnVcxKrO6goHve+5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SjAACDEMOVXDPiG3IemKySiGeIlG//+/UcQ5ObF8YEdcLON/87U/vzpzwjcaQVEQBRj2o7NpyEvNagl3omoHU9taA7SuEH7Znyi9iuz9iYIYCkGrYtiBCoe6FVTxaKx76yLxsO/obYC0eFujAk0Ci0gbkCz4q30GiMv2UT7WkQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S3odkv75; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5a089f333bdso707089eaf.3
        for <ceph-devel@vger.kernel.org>; Mon, 26 Feb 2024 10:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708972333; x=1709577133; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KwSCXSWC7LlFxAyF6W6JC6PLgPheIGOOMr28c0hOmYw=;
        b=S3odkv75KIHGTO2+GKbB/4khfg+KMfNYcNK0KAngTndhoWcDIDbRTqivpww7KvswBt
         3cbKO8cni8+7gLFGvvAlDrG6D2j/hlAbPJnLMgJRhrN2wrng1n/+jR6zGkVtO057VUgL
         K8HDPeOx9C/aK2F6jU2auE5b6BZY8GCDiemz+x4pkJv5lTqBYjS2fi8ZwveGfvBqOsfm
         cEmm+DdGVmZkdArTpLWKHfiQ05ISXWwP0mIAduf7kqE/JupqqTdLDrlTJLuTGEsSyNGc
         aY25eBRx78JFjcfVoHKwc8HkIxx53+D7zjdxr8fMX+rZ50ORc5PcxDUrQvhxtHzzUeO5
         7dXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708972333; x=1709577133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KwSCXSWC7LlFxAyF6W6JC6PLgPheIGOOMr28c0hOmYw=;
        b=h28Dmjz+q8vZ5WJfhQkQw/W5BiXMeV68hc/PtoK48WgHjtC9vnJUxDFk8YwDl5pjR2
         guOcg7bU0RM24PLCh8ejZAlh9Zkxdh8W8qX5fzz61hHN7V15GMINO7m8VdQrhL5Kivyc
         7JsEKqqeYmGDwApRbv4bLZhHFw06q0IiHs0nTeNXUX7Y8xtC4p2W26eG3BY0lCBzo9J+
         1pLq4NWjJSI3pY7/o+dGS9ud9wru0iyAiHEJ6fz5jjOAWGRjadwy/V7pEeAIKpSOmaxE
         FT8GNhXyI7lB3QUE/gvaDGAcACo983Sqj/S/OZKB4xZWzJMg4Wm4Ud3nzJQkVlUqZOCl
         ySFw==
X-Gm-Message-State: AOJu0YyrxLzTI/Bc2c1cvrR0tqoqatQ5g4FHQ1Y39ZQtrCQLUqulXqTL
	msJS3Kkr26+tf9UUcnzL43ZSnZjx+6jNPlFhWxa+YmtIoTuz59B3ZmsCqn/rSjSzPhx0BmM4z4E
	4+PaPtUXgyNJIL8DfflkaIVFeEOw=
X-Google-Smtp-Source: AGHT+IEjtGfArSNba7TQWK9fDPrCOezsG6V2rc//D0hiKHh+EKOuVXQAkH6XJvCcVTaMGe8leJb5EEf37M30yeoK65E=
X-Received: by 2002:a4a:9bd0:0:b0:5a0:8592:d8bb with SMTP id
 b16-20020a4a9bd0000000b005a08592d8bbmr3538238ook.6.1708972333645; Mon, 26 Feb
 2024 10:32:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240221045158.75644-1-xiubli@redhat.com>
In-Reply-To: <20240221045158.75644-1-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 26 Feb 2024 19:32:01 +0100
Message-ID: <CAOi1vP_194e3iemuUTVJzmdYn1AyuJ1PnCnrx9c3_pPxgNUxTw@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: reverse MDSMap dencoding of max_xattr_size/bal_rank_mask
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com, Patrick Donnelly <pdonnell@redhat.com>, 
	Patrick Donnelly <pdonnell@ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 21, 2024 at 5:54=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Ceph added the bal_rank_mask with encoded (ev) version 17.  This
> was merged into main Oct 2022 and made it into the reef release
> normally. While a latter commit added the max_xattr_size also
> with encoded (ev) version 17 but places it before bal_rank_mask.
>
> And this will breaks some usages, for example when upgrading old
> cephs to newer versions.
>
> URL: https://tracker.ceph.com/issues/64440
> Reported-by: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Reviewed-by: Patrick Donnelly <pdonnell@ibm.com>
> Reviewed-by: Venky Shankar <vshankar@redhat.com>
> ---
>
> V3:
> - Fix the comment suggested by Patrick in V2.
>
>
>  fs/ceph/mdsmap.c | 7 ++++---
>  fs/ceph/mdsmap.h | 6 +++++-
>  2 files changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index fae97c25ce58..8109aba66e02 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -380,10 +380,11 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_=
mds_client *mdsc, void **p,
>                 ceph_decode_skip_8(p, end, bad_ext);
>                 /* required_client_features */
>                 ceph_decode_skip_set(p, end, 64, bad_ext);
> +               /* bal_rank_mask */
> +               ceph_decode_skip_string(p, end, bad_ext);
> +       }
> +       if (mdsmap_ev >=3D 18) {
>                 ceph_decode_64_safe(p, end, m->m_max_xattr_size, bad_ext)=
;
> -       } else {
> -               /* This forces the usage of the (sync) SETXATTR Op */
> -               m->m_max_xattr_size =3D 0;
>         }
>  bad_ext:
>         doutc(cl, "m_enabled: %d, m_damaged: %d, m_num_laggy: %d\n",
> diff --git a/fs/ceph/mdsmap.h b/fs/ceph/mdsmap.h
> index 89f1931f1ba6..1f2171dd01bf 100644
> --- a/fs/ceph/mdsmap.h
> +++ b/fs/ceph/mdsmap.h
> @@ -27,7 +27,11 @@ struct ceph_mdsmap {
>         u32 m_session_timeout;          /* seconds */
>         u32 m_session_autoclose;        /* seconds */
>         u64 m_max_file_size;
> -       u64 m_max_xattr_size;           /* maximum size for xattrs blob *=
/
> +       /*
> +        * maximum size for xattrs blob.
> +        * Zeroed by default to force the usage of the (sync) SETXATTR Op=
.
> +        */
> +       u64 m_max_xattr_size;
>         u32 m_max_mds;                  /* expected up:active mds number =
*/
>         u32 m_num_active_mds;           /* actual up:active mds number */
>         u32 possible_max_rank;          /* possible max rank index */
> --
> 2.43.0
>

I have expanded the changelog and tagged stable as we definitely want
this backported.  Please let me know if I got something wrong:

https://github.com/ceph/ceph-client/commit/51d31149a88b5c5a8d2d33f06df93f61=
87a25b4c

Thanks,

                Ilya

