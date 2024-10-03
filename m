Return-Path: <ceph-devel+bounces-1875-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FCF098EAFC
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Oct 2024 10:02:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D6AE1C21BDB
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Oct 2024 08:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B2B212CD88;
	Thu,  3 Oct 2024 08:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a9/nsPTi"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950CA10940;
	Thu,  3 Oct 2024 08:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727942522; cv=none; b=ugLuPpThRQ+TLUqs5G/ePW9wN7YsxiLEfFOISbPCJyyCte8/PEYVB40i8AkertQYS67+rJ+LGXfxtMVkYPO3fGzZtk+sxMZz2ooxxvhuU+7M76JCZFzE1sy4lGqc5HboYwyaA5TFlaWNkUB+yGOCIO5hriBAIrdYeZ23SaDT32M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727942522; c=relaxed/simple;
	bh=JrXTAsciiQotl0LlbGjujFVQLrdU36O71q2Az9fkxgo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kQB9mdxM7nIccSVm9uweJ9v9FqJ+/1StDwXQs2vVBppilv8vPhzgdzkILf0bFEnCHPadSRIZPotxfyShhdKaPChvIoqu7VxMwsEjVvNDCGxYDuId1ONx2wKVih5idVuiqLO//dOIlZu4A8EKD6pn4MWLEnbI10B8JXiCfKe1wBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a9/nsPTi; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5e7aec9e15fso323697eaf.3;
        Thu, 03 Oct 2024 01:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727942520; x=1728547320; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H8iPGGkiy42EV22uOTr3QvtcRtuqJSAh/ft6fEGtNVI=;
        b=a9/nsPTipkmbsAWiC+g82zSPlSvouunM1el/oWrj29g3wXxVvtgF6Rl4DMOtTUsDbC
         aWJCky2TxCCFqLL8530kL+HZLa5clgDXqz3Qm/Lkv7DrQX8sZJ7xZ6dBjqlOjaeVZrxq
         +WgLR2WtA8YoF/qvLJPp+VX1jmn5NklSr/R+F0y72fl/5F3f1Hk6M8Fk/YYmId5sSb9d
         1nWgWFajIAblE86gLVohmL9/DdMpsytuf4LmEeYLJNKFX7f16PTrm58QmHpEiqY02jhv
         Qse6be6sTBhbDtB9XWPM8IQOdQ6XVfx6amZs9sfPhAlBJnyc/ykdOlKRBU6qg/3BN23T
         J14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727942520; x=1728547320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H8iPGGkiy42EV22uOTr3QvtcRtuqJSAh/ft6fEGtNVI=;
        b=lg8YO4Mvp5jVZN0fNCXyZEanE9rEI+Upc457yQkxmptkapHWQHp7GJrgy8FYvYCMri
         5Y/fBbTbhkymH308cyFSKZiqlgcZLVAOGqdP27tFFniix+B59sq4Kv3oHD8mlj6WqRev
         LA4HmDHlQGinSVcV7DTte8uRA+z8x4vjzJSyWQPAZ21k+mUkqQAROdJK34Tx0A2SsluQ
         tdkfMaefH9J2BdI18ERToODVTfyqSy2Nncf2qbwFrLBsd9RvO+QH3XlRed2tDEr9Nf61
         CmGlsDtqpwE7UNISdlVThwGrF9sUcOKT30qqKsBKqWYgkhk8RBnCSJdvxeDoDnLgRKYS
         kZ5g==
X-Forwarded-Encrypted: i=1; AJvYcCV89xwS7R+WX5Wns9PIKrTRnF6WEqWDSsdSmtWW+BszO1GIPLnPUDNxwBCN3cR4KSXKugDxkifa@vger.kernel.org, AJvYcCX+bq+voLOEG8d82sSqGWOPXKXhDw2Qk9WqcVjWvqcQUOOHcTmb87HeGHnUDtsaAlOLt12QqjKeyDrIYdkN@vger.kernel.org, AJvYcCX20V5BEwb5ZASMXzCts3Y7nDBhVn/+DwM8/KTsbR7/Wi98Z1vbKr7TM381ypR1QOkzCzsqXVm3q8lE@vger.kernel.org
X-Gm-Message-State: AOJu0YzDDMToGPgJbdTwVIoQHRDYvSguRvY3H2gYXoJqllSrD3Ode4ix
	6PvQ5yKvcnj+j/2yhNmrnEbPfUMWckZA2B7EgEdEfa8xMx7VA67UQBNvERstjZUw7JvQAa1Ry0i
	+7UHRDuarn1tTdeCtm2YCIZC1FI4=
X-Google-Smtp-Source: AGHT+IFANwTRQRATYErnMRBDs+v4/WGx3YcNUWwWplGwYEjaukbO+teMuvtltji6In4LMg9KQpdLVw4sDXk+8vbbO+E=
X-Received: by 2002:a05:6820:1625:b0:5e5:7086:ebd8 with SMTP id
 006d021491bc7-5e7b1cd5202mr3704838eaf.2.1727942519572; Thu, 03 Oct 2024
 01:01:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241003010512.58559-1-batrick@batbytes.com>
In-Reply-To: <20241003010512.58559-1-batrick@batbytes.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 3 Oct 2024 10:01:47 +0200
Message-ID: <CAOi1vP97Tqgz_OTUnMPdwJ1G5aZNOZK_a5yZ7Nu5ur9-M7qSZg@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix cap ref leak via netfs init_request
To: Patrick Donnelly <batrick@batbytes.com>
Cc: Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>, 
	David Howells <dhowells@redhat.com>, Patrick Donnelly <pdonnell@redhat.com>, stable@vger.kernel.org, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 3, 2024 at 3:05=E2=80=AFAM Patrick Donnelly <batrick@batbytes.c=
om> wrote:
>
> From: Patrick Donnelly <pdonnell@redhat.com>
>
> Log recovered from a user's cluster:
>
>     <7>[ 5413.970692] ceph:  get_cap_refs 00000000958c114b ret 1 got Fr
>     <7>[ 5413.970695] ceph:  start_read 00000000958c114b, no cache cap
>     ...
>     <7>[ 5473.934609] ceph:   my wanted =3D Fr, used =3D Fr, dirty -
>     <7>[ 5473.934616] ceph:  revocation: pAsLsXsFr -> pAsLsXs (revoking F=
r)
>     <7>[ 5473.934632] ceph:  __ceph_caps_issued 00000000958c114b cap 0000=
0000f7784259 issued pAsLsXs
>     <7>[ 5473.934638] ceph:  check_caps 10000000e68.fffffffffffffffe file=
_want - used Fr dirty - flushing - issued pAsLsXs revoking Fr retain pAsLsX=
sFsr  AUTHONLY NOINVAL FLUSH_FORCE
>
> The MDS subsequently complains that the kernel client is late releasing c=
aps.
>
> Approximately, a series of changes to this code by the three commits cite=
d
> below resulted in subtle resource cleanup to be missed. The main culprit =
is the
> change in error handling in 2d31604 which meant that a failure in init_re=
quest
> would no longer cause cleanup to be called. That would prevent the
> ceph_put_cap_refs which would cleanup the leaked cap ref.
>
> Closes: https://tracker.ceph.com/issues/67008
> Fixes: 49870056005ca9387e5ee31451991491f99cc45f ("ceph: convert ceph_read=
pages to ceph_readahead")
> Fixes: 2de160417315b8d64455fe03e9bb7d3308ac3281 ("netfs: Change ->init_re=
quest() to return an error code")
> Fixes: a5c9dc4451394b2854493944dcc0ff71af9705a3 ("ceph: Make ceph_init_re=
quest() check caps on readahead")
> Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
> Cc: stable@vger.kernel.org
> ---
>  fs/ceph/addr.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 53fef258c2bc..702c6a730b70 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -489,8 +489,11 @@ static int ceph_init_request(struct netfs_io_request=
 *rreq, struct file *file)
>         rreq->io_streams[0].sreq_max_len =3D fsc->mount_options->rsize;
>
>  out:
> -       if (ret < 0)
> +       if (ret < 0) {
> +               if (got)
> +                       ceph_put_cap_refs(ceph_inode(inode), got);
>                 kfree(priv);
> +       }
>
>         return ret;
>  }
>
> base-commit: e32cde8d2bd7d251a8f9b434143977ddf13dcec6
> --
> Patrick Donnelly, Ph.D.
> He / Him / His
> Red Hat Partner Engineer
> IBM, Inc.
> GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
>

Applied.

Thanks,

                Ilya

