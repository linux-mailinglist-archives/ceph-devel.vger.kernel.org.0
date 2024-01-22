Return-Path: <ceph-devel+bounces-626-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1925C836DDC
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 18:40:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D4F21C2781F
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 17:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FBE05B5DD;
	Mon, 22 Jan 2024 16:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GQnFqI/o"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E0A5B5DB
	for <ceph-devel@vger.kernel.org>; Mon, 22 Jan 2024 16:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705942567; cv=none; b=qDBk+HpZHgzevQsNHDH0svHwJxyq0Fb8Y90PgI4c35jl7vFJgU6H2FvjPCe2vxccmF0pc+iCZsANQpt1J/6dJ2VJCwJukv6fx/a0BEOhqeQZ+RIbT8sxzOPnX3yK6XRAfBxhoC7ba+c6ruXhHvk/48+2R6FdUYmdQKayTD957oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705942567; c=relaxed/simple;
	bh=G0KezKbFX7iUdEmjPGN2LEsoyg8vA6F7bC23LxjrlKc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DNEuHo+Tch3J/2Nr5vDmbzR+VCu3fKk7ftZ8+V7GXuPQThnzUfcvpTCVLy1W76BQCukAxxQ+tMWtLIiobCZ9Lk3lrDsOHbO8HodYopIgB/lcikgI6HO7aQJCW2b5WFrglExwZfAU44Blw2nplRtotdszP661CLoNk3I8Axkfais=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GQnFqI/o; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-598ee012192so1448106eaf.1
        for <ceph-devel@vger.kernel.org>; Mon, 22 Jan 2024 08:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705942565; x=1706547365; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dzcvD6e2VU6zFvQ+/s/VtUevIGd5U4nS4i5PLEcvnD4=;
        b=GQnFqI/oxeWV7bQftRwHzJ+rjBWUskjNi69bMYc3rmfV7vy8vmNyQJtax/aymy6ok4
         C73BUSUp0kqiFJPo2FA+aU8AaxbmxN4QOVTBlEbtLTCbPRfukqoPWb2JQal5o+N1KvgL
         A7b0XVEBEe5JmxmRhQ7nWFNkvz27RMMkmgKHKOqQinald8Z7S23Td4q5SicPkREzedPx
         CEnhZAFscNM6ki/ZlWydRPSzLK7SkBIHIbaD4Aryy3NfvMzDK/e+K7JRiNaS/Zu/FW8J
         Yi7vY4rmq/2/uItp64++LSX3rTfeOYjnbh8UiTEoDuw4l9aiirgPFJ8YVZKYLTm28IEf
         X4qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705942565; x=1706547365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dzcvD6e2VU6zFvQ+/s/VtUevIGd5U4nS4i5PLEcvnD4=;
        b=C0odR0o+xnOYIluIYRQCBTyPD7wPsor9KWw6p07pUjVeCpSBy2uzF8n9eLxvR+1icr
         MiBW+UqszJESiUTpYP51+QBj2x5NRWlBd+SocuwVksK6AYAKj1N+4/G7G6DQ2UZmBxVy
         hQz7LKbABUckYpbq2leR2SmVpR/C4w5/Tu1jxGfKeqYnEelhZf2LSpZ4VQRjGuHJSzT3
         jZ2CMBLcNBtC8dazPCtUEPYkLpYN4nhrjcPyHiVAfmMnCTS1w2io0bIoRPtDdfNPeU86
         Ovz4X90dcVxCRhXVfC7J4sVTpf1dfyUWgQptCvt4ukGqEQYbffvcuagq63RrMrxfU9AV
         nW0w==
X-Gm-Message-State: AOJu0YyYyai9KvroW/jAW24Emb0l+RtbvSuOkkjk2mlbLbPPajDuM9FI
	GNRX9tpuaWhAy6jS3dj+zAliLDH8HMS1UnXelLjCFQMqdpyrGJHky5fpAEs+k/ow0WBvhiltXVv
	7CjhYpQHW3j2VKf6ob64lGtif0e4=
X-Google-Smtp-Source: AGHT+IE0+ZfUruxLiUpP3JBQJ54Wwos6YBk128CozBoqp57KVMC+ru8vmmbfOGKj3383xjQS1bRTJ5TcbwaZYd1/ez8=
X-Received: by 2002:a4a:d888:0:b0:598:6603:e4d with SMTP id
 b8-20020a4ad888000000b0059866030e4dmr2323742oov.18.1705942565279; Mon, 22 Jan
 2024 08:56:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240118105047.792879-1-xiubli@redhat.com> <20240118105047.792879-4-xiubli@redhat.com>
 <62794a33b27424dac66d4a09515147f763acc9de.camel@kernel.org>
In-Reply-To: <62794a33b27424dac66d4a09515147f763acc9de.camel@kernel.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 22 Jan 2024 17:55:53 +0100
Message-ID: <CAOi1vP9sLmYVwpBjhyKD9mrXLUoRgXpK5EcQL0V7=uJUHuGbVw@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] libceph: just wait for more data to be available
 on the socket
To: Jeff Layton <jlayton@kernel.org>
Cc: xiubli@redhat.com, ceph-devel@vger.kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 4:02=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Thu, 2024-01-18 at 18:50 +0800, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> >
> > The messages from ceph maybe split into multiple socket packages
> > and we just need to wait for all the data to be availiable on the
> > sokcet.
> >
> > This will add 'sr_total_resid' to record the total length for all
> > data items for sparse-read message and 'sr_resid_elen' to record
> > the current extent total length.
> >
> > URL: https://tracker.ceph.com/issues/63586
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  include/linux/ceph/messenger.h |  1 +
> >  net/ceph/messenger_v1.c        | 32 +++++++++++++++++++++-----------
> >  2 files changed, 22 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messen=
ger.h
> > index 2eaaabbe98cb..ca6f82abed62 100644
> > --- a/include/linux/ceph/messenger.h
> > +++ b/include/linux/ceph/messenger.h
> > @@ -231,6 +231,7 @@ struct ceph_msg_data {
> >
> >  struct ceph_msg_data_cursor {
> >       size_t                  total_resid;    /* across all data items =
*/
> > +     size_t                  sr_total_resid; /* across all data items =
for sparse-read */
> >
> >       struct ceph_msg_data    *data;          /* current data item */
> >       size_t                  resid;          /* bytes not yet consumed=
 */
> > diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
> > index 4cb60bacf5f5..2733da891688 100644
> > --- a/net/ceph/messenger_v1.c
> > +++ b/net/ceph/messenger_v1.c
> > @@ -160,7 +160,9 @@ static size_t sizeof_footer(struct ceph_connection =
*con)
> >  static void prepare_message_data(struct ceph_msg *msg, u32 data_len)
> >  {
> >       /* Initialize data cursor if it's not a sparse read */
> > -     if (!msg->sparse_read)
> > +     if (msg->sparse_read)
> > +             msg->cursor.sr_total_resid =3D data_len;
> > +     else
> >               ceph_msg_data_cursor_init(&msg->cursor, msg, data_len);
> >  }
> >
> >
>
> Sorry, disregard my last email.
>
> I went and looked at the patch in the tree, and I better understand what
> you're trying to do. We already have a value that gets set to data_len
> called total_resid, but that is a nonsense value in a sparse read,
> because we can advance farther through the receive buffer than the
> amount of data in the socket.

Hi Jeff,

I see that total_resid is set to sparse_data_requested(), which is
effectively the size of the receive buffer, not data_len.  (This is
ignoring the seemingly unnecessary complication of trying to support
normal reads mixed with sparse reads in the same message, which I'm
pretty sure doesn't work anyway.)

With that, total_resid should represent the amount that needs to be
filled in (advanced through) in the receive buffer.  When total_resid
reaches 0, wouldn't that mean that the amount of data in the socket is
also 0?  If not, where would the remaining data in the socket go?

Thanks,

                Ilya

