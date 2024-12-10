Return-Path: <ceph-devel+bounces-2284-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95BFA9EB9DB
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Dec 2024 20:13:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 577A91887FC7
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Dec 2024 19:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68D61214222;
	Tue, 10 Dec 2024 19:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DDYaAaxe"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF0621420A
	for <ceph-devel@vger.kernel.org>; Tue, 10 Dec 2024 19:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733857983; cv=none; b=PVt8u9plsn1o8KAoib2VKzSAlCcyY7zFZ0t5fEk7keJNLMV5VwAZ67YlGiHeTpAwzum3jZMK/Tl3zOJ5CwX0BpM0yhMiffzsKhjrTFS4CBLb/vPRorgP0dxFL6y2IPCcDsW122OSWspexL18QDSKt698Ht9t5LwYb60tWoPNXHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733857983; c=relaxed/simple;
	bh=iq8WgqAR55fUoLrJYIyzGT44WwIBZkFUVgv7UpZ5vjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DnrJK4E2mbBNnN1wyP+RYqZAxPLWyhVP2OO7b+Tf1lUyqCRbcCYg1PL1Q812DcPV9LbXee7qZ1Gxmh3EpUi7lGATFR4XvQosoLdD7E0ZBZbgFJPiV9uAwfzmMdDmn+EUJCMbMIQkUjc2SlRXgUPOP5I2qZoGAoVAWXt3Qu4roVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DDYaAaxe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733857980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2jxi16m+VGTGjur5rqoVaOqUIsGqSDqNfK2cvVDUPyY=;
	b=DDYaAaxeLM2N2wipgPsXGiQPKRg0tpxfzkZhCfSlGhXCmIup7BuEZYxqhlp6ZTSRhQLAAf
	jiPODpVTh/IhJoo7I1uylzwlSXONO2A4ZV19Mvayygl+XHTKpDju+jWkJvR5qqgZDMRQn3
	1rThLMeWkLeIfMe1c8oghME54ny2mW4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-g8c0idt7MvaIwy77cwlmsw-1; Tue, 10 Dec 2024 14:12:58 -0500
X-MC-Unique: g8c0idt7MvaIwy77cwlmsw-1
X-Mimecast-MFC-AGG-ID: g8c0idt7MvaIwy77cwlmsw
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-aa69c41994dso111703966b.0
        for <ceph-devel@vger.kernel.org>; Tue, 10 Dec 2024 11:12:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733857977; x=1734462777;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2jxi16m+VGTGjur5rqoVaOqUIsGqSDqNfK2cvVDUPyY=;
        b=Lq/I+FTshK2f4CFrzqx7FgC4OpGeyIT5sKmLlVCbpXuSx/iKCxlW7bsQxu45OeBIKP
         vbqooMvGUP4KE7A5+53xBhuLcfNu8fLsr13FF4PYcHzsxb/fA6196+MiWLnbEax2E2Tr
         3WuKxWvLk+MZAt0oAo/k6KcN8SFEaN/JagM6g4KYpESw0j9UWYRKZnRpXaYvq0I/6D2B
         DpBBbwbe8QBdVwND17ckDE3W8gpUVOgyN6moDi+AozSIrBfvPvp3v27r+M1/wRDR2Sxv
         3D0SCZZRWp1q7aOCKB9AuHdtuhajtC2c/mrftzTR9xbB0lMLMbBVOOtxDeN8yybZw+nL
         D/aA==
X-Gm-Message-State: AOJu0YyeVY4fdx8gFFGbreMz37uOK3PdCaQnIXgZJHTs+rVtO0xIcGTF
	1Cnei2GV05UTgYRjo7qsotgCBb7go0tSvgfqTiRfNXVrgWh1BwOskNE5/Qv7D0SsxvFgRtuFIi/
	ear71YJ1SWjsFake8QMIIME8QyakafPRP2l3vNbdwsSCqb6RKr+H+aYZqYD8BqV7cuge0pmUdjz
	A3zC9ScIXeX8GbyPSR15CmvHVeBRVBPZIRLPuY4CHf8SQ3
X-Gm-Gg: ASbGncts+q+bkxwxbQp7y1/QeyMo4Kejy1/3g9qUtU86cUQPgx3oOSf7gdkAeUgFI6s
	pcu07JfqULCpEMo6fZ60MpuTMmyAJUMzlw2I=
X-Received: by 2002:a05:6402:51c6:b0:5d0:d818:559d with SMTP id 4fb4d7f45d1cf-5d4185073dcmr13619231a12.11.1733857977436;
        Tue, 10 Dec 2024 11:12:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEr2SWLfHNRawSFy8NMrJYlZYQ/7D+UTwuX2GbxZ91CrtnWieifj3P/tIlALEnQNfVh10p0S079edN69nsTlKc=
X-Received: by 2002:a05:6402:51c6:b0:5d0:d818:559d with SMTP id
 4fb4d7f45d1cf-5d4185073dcmr13619182a12.11.1733857977098; Tue, 10 Dec 2024
 11:12:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241209114359.1309965-1-amarkuze@redhat.com> <547b3a59c43751dfa793fef35a66f03fafea84ea.camel@ibm.com>
In-Reply-To: <547b3a59c43751dfa793fef35a66f03fafea84ea.camel@ibm.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Tue, 10 Dec 2024 21:12:46 +0200
Message-ID: <CAO8a2ShtipAxNUgrD7JkWdPG9brHjGreKnOGBQ3jYpXu+BFLpQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: improve error handling and short/overflow-read
 logic in __ceph_sync_read()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The main goal of this patch is to solve erroneous read sizes and overflows.
The convoluted 'if else' chain is a recipe for disaster. Currently,
exec stops immediately on first ret that indicates an error.
If you have additional refactoring thoughts feel free to add more
patches, This is mainly a bug fix, that solves both the immediate
overflow bug and attempts to make this code more manageable to
mitigate future bugs.

On Tue, Dec 10, 2024 at 8:13=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Mon, 2024-12-09 at 11:43 +0000, Alex Markuze wrote:
> > This patch refines the read logic in __ceph_sync_read() to ensure
> > more
> > predictable and efficient behavior in various edge cases.
> >
> > - Return early if the requested read length is zero or if the file
> > size
> >   (`i_size`) is zero.
> > - Initialize the index variable (`idx`) where needed and reorder some
> >   code to ensure it is always set before use.
> > - Improve error handling by checking for negative return values
> > earlier.
> > - Remove redundant encrypted file checks after failures. Only attempt
> >   filesystem-level decryption if the read succeeded.
> > - Simplify leftover calculations to correctly handle cases where the
> > read
> >   extends beyond the end of the file or stops short.
> > - This resolves multiple issues caused by integer overflow
> >   -
> > https://tracker.ceph.com/issues/67524
> >
> >   -
> > https://tracker.ceph.com/issues/68981
> >
> >   -
> > https://tracker.ceph.com/issues/68980
> >
> >
> > Signed-off-by: Alex Markuze <amarkuze@redhat.com>
> > ---
> >  fs/ceph/file.c | 29 ++++++++++++++---------------
> >  1 file changed, 14 insertions(+), 15 deletions(-)
> >
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index ce342a5d4b8b..8e0400d461a2 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
> > loff_t *ki_pos,
> >       if (ceph_inode_is_shutdown(inode))
> >               return -EIO;
> >
> > -     if (!len)
> > +     if (!len || !i_size)
> >               return 0;
> >       /*
> >        * flush any page cache pages in this range.  this
> > @@ -1086,7 +1086,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
> > loff_t *ki_pos,
> >               int num_pages;
> >               size_t page_off;
> >               bool more;
> > -             int idx;
> > +             int idx =3D 0;
> >               size_t left;
> >               struct ceph_osd_req_op *op;
> >               u64 read_off =3D off;
> > @@ -1160,7 +1160,14 @@ ssize_t __ceph_sync_read(struct inode *inode,
> > loff_t *ki_pos,
> >               else if (ret =3D=3D -ENOENT)
> >                       ret =3D 0;
> >
> > -             if (ret > 0 && IS_ENCRYPTED(inode)) {
>
> The whole function contains multiple places of checking ret > 0
> condition. Frankly speaking, it looks very weird. It is clear that it
> is effort to distinguish normal and erroneous execution flow. But, for
> my taste, it could be a ground for bugs. I have feelings that
> __ceph_sync_read() logic requires refactoring:
>
> if (ret < 0) {
>    <report error and stop execution>
> } else {
>    <continue normal execution flow>
> }
>
> What do you think?
>
> > +             if (ret < 0) {
> > +                     ceph_osdc_put_request(req);
> > +                     if (ret =3D=3D -EBLOCKLISTED)
> > +                             fsc->blocklisted =3D true;
> > +                     break;
> > +             }
> > +
> > +             if (IS_ENCRYPTED(inode)) {
> >                       int fret;
> >
> >                       fret =3D ceph_fscrypt_decrypt_extents(inode,
> > pages,
> > @@ -1187,7 +1194,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
> > loff_t *ki_pos,
> >               }
> >
> >               /* Short read but not EOF? Zero out the remainder.
> > */
> > -             if (ret >=3D 0 && ret < len && (off + ret < i_size)) {
> > +             if (ret < len && (off + ret < i_size)) {
> >                       int zlen =3D min(len - ret, i_size - off -
> > ret);
> >                       int zoff =3D page_off + ret;
> >
> > @@ -1197,13 +1204,11 @@ ssize_t __ceph_sync_read(struct inode *inode,
> > loff_t *ki_pos,
> >                       ret +=3D zlen;
> >               }
> >
> > -             idx =3D 0;
> > -             if (ret <=3D 0)
> > -                     left =3D 0;
> > -             else if (off + ret > i_size)
> > -                     left =3D i_size - off;
> > +             if (off + ret > i_size)
> > +                     left =3D (i_size > off) ? i_size - off : 0;
> >               else
> >                       left =3D ret;
> > +
> >               while (left > 0) {
> >                       size_t plen, copied;
> >
> > @@ -1222,12 +1227,6 @@ ssize_t __ceph_sync_read(struct inode *inode,
> > loff_t *ki_pos,
> >
> >               ceph_osdc_put_request(req);
> >
> > -             if (ret < 0) {
> > -                     if (ret =3D=3D -EBLOCKLISTED)
> > -                             fsc->blocklisted =3D true;
> > -                     break;
> > -             }
> > -
> >               if (off >=3D i_size || !more)
> >                       break;
> >       }
>
> Mostly, cleanup looks good. But I have feelings that this function
> requires
> more refactoring efforts.
>
> Thanks,
> Slava.
>


