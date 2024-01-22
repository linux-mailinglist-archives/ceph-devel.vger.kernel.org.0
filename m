Return-Path: <ceph-devel+bounces-630-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A22E98372E8
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 20:45:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6025B28F2B
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 19:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E12263FE39;
	Mon, 22 Jan 2024 19:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KbjXL7l7"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA0D3FB08
	for <ceph-devel@vger.kernel.org>; Mon, 22 Jan 2024 19:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705952505; cv=none; b=bra83DemGJD4fUJOGfBdKrsWmPNGMtBwT2Rya7rybdToGVHEo0AnEITLvS8IL3Dx2QXWAiVQdV4Zh5pfJhG8Qj1WsQ0pYESO6fa1nDBMyBiu/rm+PhQB8yK7akloPPuVP0jPiwyTJGGaCdHRI9k+IRWzHyYNySP5BCe04QYZBM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705952505; c=relaxed/simple;
	bh=qjXTuwntwW4ejqd6hLTt1n+O0Xc6Wv5is3kZQPaB3nM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZNuzMbNA+sP/z8Ty/wxtx0HlH4hxPuXFf9P55B0ulUk/naDfPy9NUWzk1UTUhsDFOdvvPWgCTtdxQpQm+MAnzCrNzN/O1BneetXNyvFX9dc/bFq4Q/1She1W4xrBPAfXW3POmPdFbBK0hxb4d8mCm+p3G2GMb5OW08KWqPtgS0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KbjXL7l7; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-214410e969cso847236fac.0
        for <ceph-devel@vger.kernel.org>; Mon, 22 Jan 2024 11:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705952503; x=1706557303; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zNngi2RN+lE6eGxbDPAGD9H9Zny6R25nhuyLmOnj8X8=;
        b=KbjXL7l78424AM3RM7Ir/m29AiHVohY/vRAcLk/TpzS2fFfr24U+sRESgY7lTNVsmr
         PLQqjzHggeysr3/Q7fr0UIfEqDxLEQcewA/6S0+6msziOYZWyDc9bH82+MCl0pCo9oj4
         Ed+Xh+biM88iODG1xtclTjGnscDkwyrI+qioeexAGSX87ZWeQn1adhe86w32cFfFKiXj
         9kgCGAS5j+A6KhuMQ3r2pZ8ohkQAUDraXIE3ufkc1gZ2shsd/VpFEH9BKCqQ/FNGDMpB
         1lNd8gVxhJyp7u/vgo51TxiTk+QJDyBRyokOGmoFmtC2vwcI2L56MPQEqJGtZcHKImb+
         bLag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705952503; x=1706557303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zNngi2RN+lE6eGxbDPAGD9H9Zny6R25nhuyLmOnj8X8=;
        b=l69BYb+3ahu2LtAbWmAubpchNfIP7MlWop91oskoltN0/863BQemo79x22zkeqhLZQ
         cPZ+qh/8nA66iE1qxwK6oIUHCCp/QeTbn0ZJULPjDBAZgJ/KJCzfJVi5Xp4+vCx8Hx3r
         v0dHEPcn3L3qlW9lmF62aL/oyAlddxI6QGvQ3y0763l0mBvvawkyYOxd1Bu2vpAm290Z
         mJtbk13wXmkvdE3gWPiI3JpTqctLox+93lumiswg+z4dXuBd9jhFW4RiUPQBvgrfETUh
         llleIau/FKTRdzi77WFsnxHs87wF7cjzTGOaCgvDqzF2h/EeLysgENlLa6bhpZ+t2DqM
         /Maw==
X-Gm-Message-State: AOJu0Yxrs3xNBXefUP+W5JEk0itT/axeK+kOhf6TAtcNzUEHJ+b9+5eJ
	uUdGIMx88ZhzJ0vDNejIhSeOMNm3fgYL7eein2x/e4sqLeD3RLFG0DtxCKjUnG7PTiWMjVYBdev
	7l0RUAVZmUSdegTOifanjA010Buo=
X-Google-Smtp-Source: AGHT+IG2JBNnWYVIcKHuTzOsRFdIOVCZPo800iEuYxzVY5AiBkSUXb/A3UdGA6o7kig0RCN9msOBCHtE2fvXEzDxmhY=
X-Received: by 2002:a05:6870:7193:b0:214:816f:8816 with SMTP id
 d19-20020a056870719300b00214816f8816mr65079oah.3.1705952503136; Mon, 22 Jan
 2024 11:41:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240118105047.792879-1-xiubli@redhat.com> <20240118105047.792879-4-xiubli@redhat.com>
 <62794a33b27424dac66d4a09515147f763acc9de.camel@kernel.org>
 <CAOi1vP9sLmYVwpBjhyKD9mrXLUoRgXpK5EcQL0V7=uJUHuGbVw@mail.gmail.com> <69fdd8a5c50987ad468567573e88a54c91ef971e.camel@kernel.org>
In-Reply-To: <69fdd8a5c50987ad468567573e88a54c91ef971e.camel@kernel.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 22 Jan 2024 20:41:30 +0100
Message-ID: <CAOi1vP8M_85Xr20swLJzjh5y4J2ZoDe4R4ZQ602MrNtV6UcVVA@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] libceph: just wait for more data to be available
 on the socket
To: Jeff Layton <jlayton@kernel.org>
Cc: xiubli@redhat.com, ceph-devel@vger.kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 6:14=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Mon, 2024-01-22 at 17:55 +0100, Ilya Dryomov wrote:
> > On Mon, Jan 22, 2024 at 4:02=E2=80=AFPM Jeff Layton <jlayton@kernel.org=
> wrote:
> > >
> > > On Thu, 2024-01-18 at 18:50 +0800, xiubli@redhat.com wrote:
> > > > From: Xiubo Li <xiubli@redhat.com>
> > > >
> > > > The messages from ceph maybe split into multiple socket packages
> > > > and we just need to wait for all the data to be availiable on the
> > > > sokcet.
> > > >
> > > > This will add 'sr_total_resid' to record the total length for all
> > > > data items for sparse-read message and 'sr_resid_elen' to record
> > > > the current extent total length.
> > > >
> > > > URL: https://tracker.ceph.com/issues/63586
> > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > ---
> > > >  include/linux/ceph/messenger.h |  1 +
> > > >  net/ceph/messenger_v1.c        | 32 +++++++++++++++++++++---------=
--
> > > >  2 files changed, 22 insertions(+), 11 deletions(-)
> > > >
> > > > diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/me=
ssenger.h
> > > > index 2eaaabbe98cb..ca6f82abed62 100644
> > > > --- a/include/linux/ceph/messenger.h
> > > > +++ b/include/linux/ceph/messenger.h
> > > > @@ -231,6 +231,7 @@ struct ceph_msg_data {
> > > >
> > > >  struct ceph_msg_data_cursor {
> > > >       size_t                  total_resid;    /* across all data it=
ems */
> > > > +     size_t                  sr_total_resid; /* across all data it=
ems for sparse-read */
> > > >
> > > >       struct ceph_msg_data    *data;          /* current data item =
*/
> > > >       size_t                  resid;          /* bytes not yet cons=
umed */
> > > > diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
> > > > index 4cb60bacf5f5..2733da891688 100644
> > > > --- a/net/ceph/messenger_v1.c
> > > > +++ b/net/ceph/messenger_v1.c
> > > > @@ -160,7 +160,9 @@ static size_t sizeof_footer(struct ceph_connect=
ion *con)
> > > >  static void prepare_message_data(struct ceph_msg *msg, u32 data_le=
n)
> > > >  {
> > > >       /* Initialize data cursor if it's not a sparse read */
> > > > -     if (!msg->sparse_read)
> > > > +     if (msg->sparse_read)
> > > > +             msg->cursor.sr_total_resid =3D data_len;
> > > > +     else
> > > >               ceph_msg_data_cursor_init(&msg->cursor, msg, data_len=
);
> > > >  }
> > > >
> > > >
> > >
> > > Sorry, disregard my last email.
> > >
> > > I went and looked at the patch in the tree, and I better understand w=
hat
> > > you're trying to do. We already have a value that gets set to data_le=
n
> > > called total_resid, but that is a nonsense value in a sparse read,
> > > because we can advance farther through the receive buffer than the
> > > amount of data in the socket.
> >
> > Hi Jeff,
> >
> > I see that total_resid is set to sparse_data_requested(), which is
> > effectively the size of the receive buffer, not data_len.  (This is
> > ignoring the seemingly unnecessary complication of trying to support
> > normal reads mixed with sparse reads in the same message, which I'm
> > pretty sure doesn't work anyway.)
> >
>
> Oh right. I missed that bit when I was re-reviewing this. Once we're in
> a sparse read we'll override that value. Ok, so maybe we don't need
> sr_total_resid.
>
> > With that, total_resid should represent the amount that needs to be
> > filled in (advanced through) in the receive buffer.  When total_resid
> > reaches 0, wouldn't that mean that the amount of data in the socket is
> > also 0?  If not, where would the remaining data in the socket go?
> >
>
> With a properly formed reply, then I think yes, there should be no
> remaining data in the socket at the end of the receive.

There would be no actual data, but a message footer which follows the
data section and ends the message would be outstanding.

>
> At this point I think I must just be confused about the actual problem.
> I think I need a detailed description of it before I can properly review
> this patch.

AFAIU the problem is that a short read may occur while reading the
message footer from the socket.  Later, when the socket is ready for
another read, the messenger invokes all read_partial* handlers,
including read_partial_sparse_msg_data().  The contract between the
messenger and these handlers is that the handler should bail if the
area of the message it's responsible for is already processed.  So,
in this case, it's expected that read_sparse_msg_data() would bail,
allowing the messenger to invoke read_partial() for the footer and
pick up where it left off.

However read_sparse_msg_data() violates that contract and ends up
calling into the state machine in the OSD client.  The state machine
assumes that it's a new op and interprets some piece of the footer (or
even completely random memory?) as the sparse-read header and returns
bogus extent length, etc.

(BTW it's why I suggested the rename from read_sparse_msg_data() to
read_partial_sparse_msg_data() in another patch -- to highlight that
it's one of the "partial" handlers and the respective behavior.)

Thanks,

                Ilya

