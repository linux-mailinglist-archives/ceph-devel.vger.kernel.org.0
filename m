Return-Path: <ceph-devel+bounces-977-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C965487F1AC
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Mar 2024 22:02:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85887281F7D
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Mar 2024 21:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2422058131;
	Mon, 18 Mar 2024 21:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lex6jj30"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612E056B8C
	for <ceph-devel@vger.kernel.org>; Mon, 18 Mar 2024 21:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710795759; cv=none; b=SSaOGjhhV02Zsh/cOb2W5irVfiPGJd8MUStWtjQwhRe/HSO7X1XGtpZKLCadWI0trPE2caK92mmrXdI3MUWahvgD5W7O+crMAFWdT5of48A4wI+p+mNTvV9TfGzpGA77x8LJyv89KAtL4ggGrnY8CG1QOkezARAO+Z/HcUiN8Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710795759; c=relaxed/simple;
	bh=kXlkkKDvZeYnAUHW/swVmIReszI7e40Wbb8P/667cIk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BV0G/ppiRGwp5GA+YyHgWq3jEOvc4mZ6EFUr9DO0b9xNk7sDZ1e2Sca04nEgx4vh/eJfIqzJBEsaZiY5J+ZCAqfa767CWtP9fuYdZ+VQ0B6dMzTZ8ip14ZR+6D+FD2yl/fmNmWRFsB0bKaKezhsMiCSdoiLngMN/Gx0grkREG6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lex6jj30; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5a47abe2ff7so1826149eaf.0
        for <ceph-devel@vger.kernel.org>; Mon, 18 Mar 2024 14:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710795757; x=1711400557; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e7jkEibYA9TpzuiyO8elcIoBPgSGZxgxOeDqtJHAF0E=;
        b=Lex6jj30ptYPfLyrPP/M7LBg3ENrebcrqqrwiNZc+dHVu76yAIpHgcgDimVvr8PG3O
         Cq7VHhfsMD/udZ/+5wgL0OHVZZ5oCWd4uKwBnNnmiGfhn6sDf1jeior/Pudp4wLfhj42
         ZIe1y62ahBvXy0lS0m2RYDAIpO/HMLjuRueVzNpNNch1cJxynAlb6pTdTXRYtuAfPWBC
         sUSTN90X0wwNAqTBDzX/tAbehmi1bpyXojp1jVOH5ys6Ajjm5fDRkH1fgf/320F0h/SZ
         Ag43hV9nhU7klpUelh9zRd1FUe+T7S6Jd+Lv9CyMBttlnCqEKpHceY2HMCfWubcpAxCt
         efGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710795757; x=1711400557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e7jkEibYA9TpzuiyO8elcIoBPgSGZxgxOeDqtJHAF0E=;
        b=nFT38Kvf94F46kXFWltimmFmVq2sUTzwiEoBZMc6WJuEhpkmqOfTywI8gYWEluF5jD
         h4KSqqhEOHumycE7MmOV21HCBkOK9q7sfSmfWCU2G+fol8BHjv7YFvU67hSXsjA4KshP
         viCrjFzQnROgoHypZ7sRnDsBpBDLIcEiV9F3gshPYAwLdSNd0j72Z3704hwbTFUDVh21
         e0ACbdQzdfB8YaNgohwysrk/LlQCyygMIAxIAgDmlcveslR+Ud8HTzX1fifGRAmbgkIm
         uhx5E0HjyUMqu1ZTUl4ZMexfxD9AdrsJhVwz0iQARl7pdL9SgvEaA0OKvwUykW0rHMPf
         /1Pw==
X-Gm-Message-State: AOJu0Yzli3F6nyQtSDP1v/5gc46OPCsDxAZ3cxMouw7QReTY7/ZrxZYg
	EePAahvOlpizYaNi14r4L8H5C1fqrGEvV4o+qa/q66BCpuphCK776UeUbZeoAP1q4gfwc0PSIX5
	Ly77vOt1LP+KVL1FbSMBa/tutCyE=
X-Google-Smtp-Source: AGHT+IGGLwN4jcXnuXICx0BgQDJ3ZbbINJZhCSx90mdw+GkM7Gn0Lphw/+SOvfjr/AnyfaYJSXSmFjnvtQK4EwHAfNE=
X-Received: by 2002:a4a:2441:0:b0:5a4:52d3:39a9 with SMTP id
 v1-20020a4a2441000000b005a452d339a9mr8199465oov.9.1710795757300; Mon, 18 Mar
 2024 14:02:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222131900.179717-1-xiubli@redhat.com> <20240222131900.179717-2-xiubli@redhat.com>
In-Reply-To: <20240222131900.179717-2-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 18 Mar 2024 22:02:25 +0100
Message-ID: <CAOi1vP-eqXSzfQ82AB9yxqKvSHoV43FVg3WnFupDo=v1fLvaUg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ceph: skip copying the data extends the file EOF
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com, =?UTF-8?B?RnJhbmsgSHNpYW8g6JWt5rOV5a6j?= <frankhsiao@qnap.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2024 at 2:21=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> If hits the EOF it will revise the return value to the i_size
> instead of the real length read, but it will advance the offset
> of iovc, then for the next try it may be incorrectly skipped.
>
> This will just skip advancing the iovc's offset more than i_size.
>
> URL: https://patchwork.kernel.org/project/ceph-devel/list/?series=3D81932=
3
> Reported-by: Frank Hsiao =E8=95=AD=E6=B3=95=E5=AE=A3 <frankhsiao@qnap.com=
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/file.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 71d29571712d..2b2b07a0a61b 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1195,7 +1195,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_=
t *ki_pos,
>                 }
>
>                 idx =3D 0;
> -               left =3D ret > 0 ? ret : 0;
> +               left =3D ret > 0 ? umin(ret, i_size) : 0;

Hi Xiubo,

Can ret (i.e. the number of bytes actually read) be compared to i_size
without taking the offset into account?  How does this a handle a case
where e.g.

    off =3D 20
    ret =3D 10
    i_size =3D 25

Did you intend the copy_page_to_iter() loop to go over 10 bytes and
therefore advance the iovc ("to") by 10 instead of 5 bytes here?

Thanks,

                Ilya

