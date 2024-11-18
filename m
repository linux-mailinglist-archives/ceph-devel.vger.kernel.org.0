Return-Path: <ceph-devel+bounces-2158-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41A409D0F46
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2024 12:09:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB8ABB263F8
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2024 10:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C6A1198A1A;
	Mon, 18 Nov 2024 10:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aMkceYBh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83F21974F4;
	Mon, 18 Nov 2024 10:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731927347; cv=none; b=CaOhA7rRZSH5U3IKBWg3wGn+dqPkGGvcaJXh0drkIqzwKDhtGibUXk1LlET3gUEV227/mRZxbQ1xyVlAbo5OkDog02a+8d8JbgsaTFaDqJVO3hfb+rrLChtTwnuZJjyQNBPAvDqFaKoF54pWO4Fkowk5d1CfaHxQdeuocxERStc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731927347; c=relaxed/simple;
	bh=XrxJFbR4MQoW2o/fbLY4lLQhXloc5UbZCeFW3e4x++4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CB2lTaQ60PMLFLLAv9f3Kqwa5zzTlAM7nifc5CDsAUSO2auId0CNcL8q7QSV1XgGno06pZ/qG8BCREmkKV20ureW2e83mxgQx0ky+jkoP2xgDL909dwkH78a/5iVBXq4b8hdWJJyVGVCzzki3D/Yz2Sp/6w+QoVQUdXlrnzex/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aMkceYBh; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-71e49ad46b1so2941272b3a.1;
        Mon, 18 Nov 2024 02:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731927345; x=1732532145; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zyoUF906vNtPyaYS/wrAUzlwsqzoKAFutcf7XV6IzlU=;
        b=aMkceYBhHTjkf/lbcgGW+KfrCgzSSF5cTU2DCk9UCkXIksjPYvM3fkitXs+D68M88C
         j2gaqgzIYFCGb0G/H+Xsh2oEm+UNVDQLsrRhhiwb2bVNWOZtMzFocEG2Vdn7ysijNfkk
         VMWiB0pT32HfauZNpVBJCSnxj6Bx3QA7jSxUXZzRHxRLSCPDLQTMyMY6nqXeZ9nTRE1j
         Pi99ReOuM+EUbFF6kU4IHxqOFadTQeH0NKlxUaCr1lIt1XwCe7lO9dzNGv1lS0d6qhFa
         bhMGWSNI1d9KZPEK4khcO/ke1bxl8aerIpN3Aw0Rlo/j54qJ4p2d7IwP83DJf0MAZuGX
         jCGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731927345; x=1732532145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zyoUF906vNtPyaYS/wrAUzlwsqzoKAFutcf7XV6IzlU=;
        b=n/8ckeMr3OSkdH/BS1wdpGQo8LJJw/nSb4ze1Cc5zoaug34JSTGkfvv6Vc7fNiUqpg
         Hzeoyaa7bPbUnEF/ofl9wvoLMR9iI2CF1nzRLb5uISPmiefiCvWCnibvNaTM6dQL+KCe
         AR6+4aYPH5UAX97Xn0ti6HI/58MYcRnetAIdOBCbqYirwQtwHjfAF1/NP8lMnaqd+wHT
         Y/6v7IZbLRVM3UNx+DGBUZSmaA6WPfBJZiPq/sGkuzGgkuEE41gKlYJNn8+Q1LTO8z4y
         N72Bk6WwTj+QNqZMCQB5zezJMiED6tcC0kECP4rqH7GCx4nHfPfIQFxW/pz1jm71JK4E
         HUZg==
X-Forwarded-Encrypted: i=1; AJvYcCV8pvxiJpO6RcY2msiKOezKrBwJAdRhWDFlxG2shdngNGgJ+HrmMuzAHqdrgJy3pzFFxk8yfox3O9vwYzOQ@vger.kernel.org, AJvYcCVjrzsL2m6f5x7M5RHoni75c4rWtdnAN0xRoeCFuF9DORf8rUSXAR38oNttLxRn+iLLqm4k+U9i5XCM@vger.kernel.org
X-Gm-Message-State: AOJu0YzgUuF4iS6vHldg5cZWGTalds4jIXrhLY/TjVpRyWZN7W4yOMRv
	9HbEHXTpLPgnxxhZLsuCX4/b56SsYQnToc2B/PdNcc0wdsSBSXv4bhMhoZO9B8mC0P4rpBTqlz2
	rqIqztmNDsbOb89vPf6GsULFlBqg=
X-Google-Smtp-Source: AGHT+IHd9jGYZ2LfCXCCzgcTK3nczwcWZWElt9W3tdeSrUmsSdK8SCvUKEicnE44ToNpMw0wHSdxbKt5yUFWNXw91Lg=
X-Received: by 2002:a05:6a00:cc2:b0:70d:265a:eec6 with SMTP id
 d2e1a72fcca58-72476bb89bemr17584252b3a.13.1731927345149; Mon, 18 Nov 2024
 02:55:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241022144838.1049499-1-batrick@batbytes.com> <20241022144838.1049499-3-batrick@batbytes.com>
In-Reply-To: <20241022144838.1049499-3-batrick@batbytes.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 18 Nov 2024 11:55:34 +0100
Message-ID: <CAOi1vP_S75CpvjRG5DXinG20PUOqc3Kf+nxtRjmZekjDbM+q1g@mail.gmail.com>
Subject: Re: [PATCH 2/3] ceph: correct ceph_mds_cap_peer field name
To: Patrick Donnelly <batrick@batbytes.com>
Cc: Xiubo Li <xiubli@redhat.com>, Patrick Donnelly <pdonnell@redhat.com>, 
	"open list:CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)" <ceph-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 22, 2024 at 4:49=E2=80=AFPM Patrick Donnelly <batrick@batbytes.=
com> wrote:
>
> See also ceph.git commit: "include/ceph_fs: correct ceph_mds_cap_peer fie=
ld name".
>
> See-also: https://tracker.ceph.com/issues/66704
> Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
> ---
>  fs/ceph/caps.c               | 23 ++++++++++++-----------
>  include/linux/ceph/ceph_fs.h |  2 +-
>  2 files changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index bed34fc11c91..88a674cf27a8 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4086,17 +4086,17 @@ static void handle_cap_export(struct inode *inode=
, struct ceph_mds_caps *ex,
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         u64 t_cap_id;
>         unsigned mseq =3D le32_to_cpu(ex->migrate_seq);
> -       unsigned t_seq, t_mseq;
> +       unsigned t_issue_seq, t_mseq;
>         int target, issued;
>         int mds =3D session->s_mds;
>
>         if (ph) {
>                 t_cap_id =3D le64_to_cpu(ph->cap_id);
> -               t_seq =3D le32_to_cpu(ph->seq);
> +               t_issue_seq =3D le32_to_cpu(ph->issue_seq);
>                 t_mseq =3D le32_to_cpu(ph->mseq);
>                 target =3D le32_to_cpu(ph->mds);
>         } else {
> -               t_cap_id =3D t_seq =3D t_mseq =3D 0;
> +               t_cap_id =3D t_issue_seq =3D t_mseq =3D 0;
>                 target =3D -1;
>         }
>
> @@ -4134,12 +4134,12 @@ static void handle_cap_export(struct inode *inode=
, struct ceph_mds_caps *ex,
>         if (tcap) {
>                 /* already have caps from the target */
>                 if (tcap->cap_id =3D=3D t_cap_id &&
> -                   ceph_seq_cmp(tcap->seq, t_seq) < 0) {
> +                   ceph_seq_cmp(tcap->seq, t_issue_seq) < 0) {
>                         doutc(cl, " updating import cap %p mds%d\n", tcap=
,
>                               target);
>                         tcap->cap_id =3D t_cap_id;
> -                       tcap->seq =3D t_seq - 1;
> -                       tcap->issue_seq =3D t_seq - 1;
> +                       tcap->seq =3D t_issue_seq - 1;
> +                       tcap->issue_seq =3D t_issue_seq - 1;
>                         tcap->issued |=3D issued;
>                         tcap->implemented |=3D issued;
>                         if (cap =3D=3D ci->i_auth_cap) {
> @@ -4154,7 +4154,7 @@ static void handle_cap_export(struct inode *inode, =
struct ceph_mds_caps *ex,
>                 int flag =3D (cap =3D=3D ci->i_auth_cap) ? CEPH_CAP_FLAG_=
AUTH : 0;
>                 tcap =3D new_cap;
>                 ceph_add_cap(inode, tsession, t_cap_id, issued, 0,
> -                            t_seq - 1, t_mseq, (u64)-1, flag, &new_cap);
> +                            t_issue_seq - 1, t_mseq, (u64)-1, flag, &new=
_cap);
>
>                 if (!list_empty(&ci->i_cap_flush_list) &&
>                     ci->i_auth_cap =3D=3D tcap) {
> @@ -4268,14 +4268,14 @@ static void handle_cap_import(struct ceph_mds_cli=
ent *mdsc,
>                 doutc(cl, " remove export cap %p mds%d flags %d\n",
>                       ocap, peer, ph->flags);
>                 if ((ph->flags & CEPH_CAP_FLAG_AUTH) &&
> -                   (ocap->seq !=3D le32_to_cpu(ph->seq) ||
> +                   (ocap->seq !=3D le32_to_cpu(ph->issue_seq) ||
>                      ocap->mseq !=3D le32_to_cpu(ph->mseq))) {
>                         pr_err_ratelimited_client(cl, "mismatched seq/mse=
q: "
>                                         "%p %llx.%llx mds%d seq %d mseq %=
d"
>                                         " importer mds%d has peer seq %d =
mseq %d\n",
>                                         inode, ceph_vinop(inode), peer,
>                                         ocap->seq, ocap->mseq, mds,
> -                                       le32_to_cpu(ph->seq),
> +                                       le32_to_cpu(ph->issue_seq),
>                                         le32_to_cpu(ph->mseq));
>                 }
>                 ceph_remove_cap(mdsc, ocap, (ph->flags & CEPH_CAP_FLAG_RE=
LEASE));
> @@ -4350,7 +4350,7 @@ void ceph_handle_caps(struct ceph_mds_session *sess=
ion,
>         struct ceph_snap_realm *realm =3D NULL;
>         int op;
>         int msg_version =3D le16_to_cpu(msg->hdr.version);
> -       u32 seq, mseq;
> +       u32 seq, mseq, issue_seq;
>         struct ceph_vino vino;
>         void *snaptrace;
>         size_t snaptrace_len;
> @@ -4375,6 +4375,7 @@ void ceph_handle_caps(struct ceph_mds_session *sess=
ion,
>         vino.snap =3D CEPH_NOSNAP;
>         seq =3D le32_to_cpu(h->seq);
>         mseq =3D le32_to_cpu(h->migrate_seq);
> +       issue_seq =3D le32_to_cpu(h->issue_seq);
>
>         snaptrace =3D h + 1;
>         snaptrace_len =3D le32_to_cpu(h->snap_trace_len);
> @@ -4598,7 +4599,7 @@ void ceph_handle_caps(struct ceph_mds_session *sess=
ion,
>                 cap->cap_id =3D le64_to_cpu(h->cap_id);
>                 cap->mseq =3D mseq;
>                 cap->seq =3D seq;
> -               cap->issue_seq =3D seq;
> +               cap->issue_seq =3D issue_seq;

Hi Patrick,

This isn't just a rename -- a different field is decoded and assigned
to cap->issue_seq now.  What is the impact of this change and should it
be mentioned in the commit message?

Thanks,

                Ilya

