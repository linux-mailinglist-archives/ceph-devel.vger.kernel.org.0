Return-Path: <ceph-devel+bounces-3907-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 46939C2DF47
	for <lists+ceph-devel@lfdr.de>; Mon, 03 Nov 2025 20:59:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 916341894FA3
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Nov 2025 19:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E652BCF54;
	Mon,  3 Nov 2025 19:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hJjJmrtX"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0005023372C
	for <ceph-devel@vger.kernel.org>; Mon,  3 Nov 2025 19:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762199941; cv=none; b=SEg1Ul8eO1XT2VTz/USLVbfNq+Pl6UA+FyoOEVNmiEXH69uZf8jqvjdy9nLPLrk875Q2BtpaxFVKOTI3o4Xzy9vIQFfKhQArBVkLoKn0iR3qoZ5mwDZ63o5IfsD3qHfILayE5rGNTmSiZnFLmZVpKN5Oww2qfW6mfka++HaN1eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762199941; c=relaxed/simple;
	bh=7q4pM3Xb7E1uNd//nS8BqYRs4/PU+D3Ma23uRkfg0Qk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bwBF6mDVYeB2JDdnNqaeynV+nAZK43pnpyjqqWC2A+/2y92vV8NRDYeCiwbae+lTANvuxBv7qkn5edI07xSQEEBuv5aaMwlIcI8cMJ0W4jYbV0XcmRBplrolTUfVK4alp5kxgvfOJ9xiM9fDz8xn8v9cYhCDCBNrZwyr8/s7Mzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hJjJmrtX; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2952048eb88so49615965ad.0
        for <ceph-devel@vger.kernel.org>; Mon, 03 Nov 2025 11:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762199939; x=1762804739; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PRL3ScLiWS5r2MDUzg9ClFfrht8FkZln8Q5mKnzs+ZY=;
        b=hJjJmrtXfAO5RnnrqKxRmCEJb5XsH8sXVpS2BB0HfVhCvV5WavuAeT9m0RTKh4jk8O
         KmadhoNk/YMIJQZXN7V6yA3qN4XZZWp6xM/8fBOGphD5OCTVp3e5AZ+F1RRZeYhqKHXs
         8hWYiiBuYni4I4AVym95sZXwbKk4dCFudWOUFOa/d17NVnXBhCF0hSQE7lKMBq8EeMOS
         zCYd333qzcLd8VRPQ08iKQLopfxfW/S79U4DpaBBvNeJJJ69nYLOlvJHtvt9YWztxhIb
         w6alCALOKyxFGFYZj4f3rRVeL/UyLjImLWaESIxYfVHjXnBhdvcIe4XNvSZianxDh/yI
         YiNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762199939; x=1762804739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PRL3ScLiWS5r2MDUzg9ClFfrht8FkZln8Q5mKnzs+ZY=;
        b=Q/LFVh/qB/e78TIwtUDzGsEDFrPxsalMFY0AV4vGe6rCPbCCxpH6XOHENZW/YeAS/u
         PGHBcZfJMiyXGVZHFUaeFlNd6wLh9BhiWgVHIrcTcmXPfNQmTOgSuhaujTqyiLn+FmbD
         3Wy3CIb+I4VnJwKqt8ZLfQhLpgbU35SSFmkLkDW9lF46N52QE56j/iT8dpHYhCMPqGo2
         irs2ET+zKZoXhS5RcE6sT97AR//+U1F1ySAoQZb+voxDf5nlCQ4NEH9y+mURAlGLmomz
         taoFucwHSPBYQ7Ye77S85/UH0KU2iBMbMsvP4t9Z5fBXmGiRcvgDh53+rxfP4kZJnnir
         zHuw==
X-Forwarded-Encrypted: i=1; AJvYcCW/g8iBu1c61pOiTlV+4EnpzeeQzD5b9uAzJbluMQliAbQpAYSR0CIvhRw9Qr1VVpLSXscfSkVBImUV@vger.kernel.org
X-Gm-Message-State: AOJu0YwkrLFzGTFGfIil1UQXpSu1A5Rl70aD6sUyhqcMu0m/bhwZDXKS
	VNA8yZ4VXrQ6Pj9vV7r1kMe6La6I2f8ykTDR4i1lbP6VQXTef+bzcFw31GSbAJ79d2bEb4BfEPL
	qw5PUPWlAnDgMos5Qt45d2F42GI+9gzE=
X-Gm-Gg: ASbGncvu+bzSmdgTECQ7gNOn2GWklUawVrGV50MkvDvVoStco9Or817SnaNQ26IuJZj
	POWXBRfDKQ8LL+Frj5FhmTZ+QC/vTxO7pcnw4a4PolmwCPJgdAP5i482llnUgCeRcbYXb7I6k9s
	x3lAUQkp6ra4SmtWgNhqe5gbp7w8pg7wav0kjleksztin3lbITEl/zSn/CfHUwNPF3DEO7th3+b
	yfp15ITSFNoHANGlBeBS8TzwHKxUsVqvDl8JuA6/X4JmWXkLvJtCHqByEF0QXUUEODp/g8=
X-Google-Smtp-Source: AGHT+IEWuX3dlSNA9ptTfOP60ilI+6QAg2Djc7tFHPEdSqDQ1aelp6YGIUK+BS3UC2DkdnTMWkra+ckpLt644WkgiX8=
X-Received: by 2002:a17:902:d2cb:b0:293:e5f:85b7 with SMTP id
 d9443c01a7336-2951a38de8cmr213138925ad.11.1762199939277; Mon, 03 Nov 2025
 11:58:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821225147.37125-2-slava@dubeyko.com> <CAOi1vP_ELOunNHzg5LgDPPAye-hYviMPNED0NQ-f9bGaHiEy8A@mail.gmail.com>
 <5e6418fa61bce3f165ffe3b6b3a2ea5a9323b2c7.camel@ibm.com>
In-Reply-To: <5e6418fa61bce3f165ffe3b6b3a2ea5a9323b2c7.camel@ibm.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 3 Nov 2025 20:58:46 +0100
X-Gm-Features: AWmQ_bkKhOiN2NGdFGlTH3aQyYQWzzHYQk5yIUTRkWhwqBe7QGKP9d4W7lmsgYE
Message-ID: <CAOi1vP8PCByY3dKu9cSDWo8B9QMaqRT23BYzkd1Q2H0Vs=YjxA@mail.gmail.com>
Subject: Re: [PATCH v8] ceph: fix slab-use-after-free in have_mon_and_osd_map()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "slava@dubeyko.com" <slava@dubeyko.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Patrick Donnelly <pdonnell@redhat.com>, 
	Alex Markuze <amarkuze@redhat.com>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2025 at 4:34=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> Hi Ilya,
>
> On Sun, 2025-10-12 at 22:37 +0200, Ilya Dryomov wrote:
> > On Fri, Aug 22, 2025 at 12:52=E2=80=AFAM Viacheslav Dubeyko <slava@dube=
yko.com> wrote:
> > >
> > >
>
> <skipped>
>
> > >
> > > v8
> > > Ilya Dryomov has pointed out that __ceph_open_session()
> > > has incorrect logic of two nested loops and checking of
> > > client->auth_err could be missed because of it.
> > > The logic of __ceph_open_session() has been reworked.
> >
> > Hi Slava,
> >
> > I was confused for a good bit because the testing branch still had v7.
> > I went ahead and dropped it from there.
> >
>
> I decided to finish our discussion before changing anything in testing br=
anch.
>
> > >
> > > Reported-by: David Howells <dhowells@redhat.com>
> > > Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> > > cc: Alex Markuze <amarkuze@redhat.com>
> > > cc: Ilya Dryomov <idryomov@gmail.com>
> > > cc: Ceph Development <ceph-devel@vger.kernel.org>
> > > ---
> > >  net/ceph/ceph_common.c | 43 +++++++++++++++++++++++++++++++++++-----=
--
> > >  net/ceph/debugfs.c     | 17 +++++++++++++----
> > >  net/ceph/mon_client.c  |  2 ++
> > >  net/ceph/osd_client.c  |  2 ++
> > >  4 files changed, 53 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> > > index 4c6441536d55..2a7ca942bc2f 100644
> > > --- a/net/ceph/ceph_common.c
> > > +++ b/net/ceph/ceph_common.c
> > > @@ -790,8 +790,18 @@ EXPORT_SYMBOL(ceph_reset_client_addr);
> > >   */
> > >  static bool have_mon_and_osd_map(struct ceph_client *client)
> > >  {
> > > -       return client->monc.monmap && client->monc.monmap->epoch &&
> > > -              client->osdc.osdmap && client->osdc.osdmap->epoch;
> > > +       bool have_mon_map =3D false;
> > > +       bool have_osd_map =3D false;
> > > +
> > > +       mutex_lock(&client->monc.mutex);
> > > +       have_mon_map =3D client->monc.monmap && client->monc.monmap->=
epoch;
> > > +       mutex_unlock(&client->monc.mutex);
> > > +
> > > +       down_read(&client->osdc.lock);
> > > +       have_osd_map =3D client->osdc.osdmap && client->osdc.osdmap->=
epoch;
> > > +       up_read(&client->osdc.lock);
> > > +
> > > +       return have_mon_map && have_osd_map;
> > >  }
> > >
> > >  /*
> > > @@ -800,6 +810,7 @@ static bool have_mon_and_osd_map(struct ceph_clie=
nt *client)
> > >  int __ceph_open_session(struct ceph_client *client, unsigned long st=
arted)
> > >  {
> > >         unsigned long timeout =3D client->options->mount_timeout;
> > > +       int auth_err =3D 0;
> > >         long err;
> > >
> > >         /* open session, and wait for mon and osd maps */
> > > @@ -813,13 +824,31 @@ int __ceph_open_session(struct ceph_client *cli=
ent, unsigned long started)
> > >
> > >                 /* wait */
> > >                 dout("mount waiting for mon_map\n");
> > > -               err =3D wait_event_interruptible_timeout(client->auth=
_wq,
> > > -                       have_mon_and_osd_map(client) || (client->auth=
_err < 0),
> > > -                       ceph_timeout_jiffies(timeout));
> > > +
> > > +               DEFINE_WAIT_FUNC(wait, woken_wake_function);
> > > +
> > > +               add_wait_queue(&client->auth_wq, &wait);
> > > +
> > > +               if (!have_mon_and_osd_map(client)) {
> >
> > Only half of the original
> >
> >     have_mon_and_osd_map(client) || (client->auth_err < 0)
> >
> > condition is checked here.  This means that if finish_auth() sets
> > client->auth_err and wakes up client->auth_wq before the entry is added
> > to the wait queue by add_wait_queue(), that wakeup would be missed.
> > The entire condition needs to be checked between add_wait_queue() and
> > remove_wait_queue() calls -- anything else is prone to various race
> > conditions that lead to hangs.
> >
> > > +                       if (signal_pending(current)) {
> > > +                               err =3D -ERESTARTSYS;
> > > +                               break;
> >
> > If this break is hit, remove_wait_queue() is never called and on top of
> > that __ceph_open_session() returns success.  ERESTARTSYS gets suppresse=
d
> > and so instead of aborting the opening of the session the code proceeds
> > with setting up the debugfs directory and further steps, all with no
> > monmap or osdmap received or even potentially in spite of a failure to
> > authenticate.
> >
>
> As far as I can see, we are stuck in the discussion. I think it will be m=
ore
> productive if you can write your own vision of this piece of code. We are=
 still
> not on the same page and we can continue this hide and seek game for a lo=
ng time
> yet. Could you please write your vision of this piece of modification?

Hi Slava,

Sure, I can take over and offer my own patch.

Thanks,

                Ilya

