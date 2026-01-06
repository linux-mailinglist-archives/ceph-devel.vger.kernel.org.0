Return-Path: <ceph-devel+bounces-4265-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DEBDCFAF33
	for <lists+ceph-devel@lfdr.de>; Tue, 06 Jan 2026 21:34:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7D42930A2E1D
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jan 2026 20:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 140AE34C801;
	Tue,  6 Jan 2026 19:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D8SVg0Ub"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEB934A77A
	for <ceph-devel@vger.kernel.org>; Tue,  6 Jan 2026 19:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767728218; cv=none; b=l+xyhKOSkIu7+w3jnYYctVqe5tbLKwl1M1kvOcH9f5gIjsdkXyYZ2r5H+LywZzjbfqs/Nrb21KopM43f6RChYiOCQ+COgHq96hxr4l4P0xAmppnq2gl/UuN4aianZGc0rYdEYjAhZLie6PXXw9YgeY0720xiVXrHmtlS5zLY9Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767728218; c=relaxed/simple;
	bh=+vK+pbCHg5AuQAMNcH7Xsrybo0VYc4JXzWJh91HOwvU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u4TWE0mWNkBt8Y2sGRlTvF4dqSedaiIqwQqi4fLvGH0vP1hz74OxkO0HaI7fetNiBDSJV8JpKSnpYuQ2WJ4BWbUtfG5pY/MWcnUuKlQ+zK/klBML+2uVFiDEawqm8sNvp38jBwJ0p4iG6UfgS2EaJr5G8FPQskzSjIwSjdN5VCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D8SVg0Ub; arc=none smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-121a0bcd364so758380c88.0
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jan 2026 11:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767728216; x=1768333016; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WXjjaYaIKrw+gTeYW42cDMRYVRUc3JfFOvkovGI9dKg=;
        b=D8SVg0UbobYJfTaeJ1nUeYQHUme/36dKFkmxX43woE+6u+uodSFn46UPlucgCi8kDq
         8up0oxb+2TThSQhfyh1CkqeY2Nz8IAWrHzRoBBzxnfWK3/WPYl3gyMef14/8ACEGWKrN
         c/cwqQwYg04VXQewW0D0X4bGqB4Yfm+54tPPgRI9iN5RPIDzq585ta3txylsruqGZ0DU
         FX7oUJ5LYDgHHm7HCisrJyToaKz7JpIjqszMK+n3SsKRuBG7UPcikJVwbwmfobmZ6bWi
         us2gKlh6ccMqj+c+Ws05cQw+U+onnpKbdFO5u1cQ8MsDZsBE2sP8kTaENFenuz8YqBP1
         VGJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767728216; x=1768333016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WXjjaYaIKrw+gTeYW42cDMRYVRUc3JfFOvkovGI9dKg=;
        b=GuPTFg0z+xbZ69NSVEJL4Wik476UJUeSIwAC6klnfKU+uewoI6bKbQq7stGZNxjDoS
         oKZGMKrXY6m6lXBJJh8/JhsID1V6nDm+HAdxE9syxYWBVAxv8LSkZJJsMqRpjQaL5oMF
         +OG3KdgkRlGw0OwJtc8lRlIoBH4NgpIzwXtChh6g8iLIdnd7zo4GGoqsiTW7FBEpMGa/
         Xyh73NTN90L5jrMKsjOVVgL4Gt8Eq+VlMl3soMjDQ8/Shi/szKv4DrnuuYszNarwWDEQ
         D/KWi1IgO8AmAXBrLwifAkEVaWuD1yQAj+5n/KM9LgNUJhsS4VnoxT9E+lJ2kIdeH45U
         qH3w==
X-Gm-Message-State: AOJu0Yw4+rTtW3k/FxFfVfP/48ekpno7DErJnlgRr+EEo1SBLCzDmF/c
	aqxItz1KacvQTiadUX2G7UVfgvoLAqxFJHYIDup0+0tlKl4hGfJINYcaLoRhX484CxlW3/WPWqF
	OuLxJTZU1ArrBtLsBuM/CqT8mL7aQzbU=
X-Gm-Gg: AY/fxX5u9xQbdlVrrU4hw8w44MIm12HjvXTPYfe4FdN3g/kj3yVmAQq1g5hGTDM0Eqf
	1sPaPabtR1P2taX56j0xNM5z+hW2mkuMaCRB0iYMlB3v1prwV+AkcRW/UdIENL5BTZbOS5beZ7k
	6OLEL9v8Ym8XjzJ08/itaMWygwWZY7lfVhz4UMGr7mvSV1WzQVlznpTBS3UmdJh31/Nc97x4tTT
	WRqmgx0NgOxumm29JHgL3wOYs2T9oTotj99kuz8RgXq+J7ARUOwvq9nTY/OH2soObCC5uw=
X-Google-Smtp-Source: AGHT+IE3zlqf6Rsg2NfEghTtEap2r7VGTGyPvf/chDcA2HhBdTWu7/EJ540dNhazupWOs+mIPT5IqVMGjG1guvh35hQ=
X-Received: by 2002:a05:7022:429e:b0:119:e56c:18a9 with SMTP id
 a92af1059eb24-121f8b14700mr57733c88.17.1767728216103; Tue, 06 Jan 2026
 11:36:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260105213509.24587-1-idryomov@gmail.com> <5ed8e36b5ce24a324e31f5567d338bd35930bdfa.camel@ibm.com>
In-Reply-To: <5ed8e36b5ce24a324e31f5567d338bd35930bdfa.camel@ibm.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 6 Jan 2026 20:36:43 +0100
X-Gm-Features: AQt7F2oQRHfLSMv06DcBnsmZ5YCXDZrZnCfM6HxbwDiaaNQDtrFUtdTVYpxPf7g
Message-ID: <CAOi1vP81_aedyGGE+sgXLyu+K6ecW3uxJ28baqu_kERuQHpwKg@mail.gmail.com>
Subject: Re: [PATCH] libceph: make calc_target() set t->paused, not just clear it
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"raphael.zimmer@tu-ilmenau.de" <raphael.zimmer@tu-ilmenau.de>, Alex Markuze <amarkuze@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 11:47=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Mon, 2026-01-05 at 22:34 +0100, Ilya Dryomov wrote:
> > Currently calc_target() clears t->paused if the request shouldn't be
> > paused anymore, but doesn't ever set t->paused even though it's able to
> > determine when the request should be paused.  Setting t->paused is left
> > to __submit_request() which is fine for regular requests but doesn't
> > work for linger requests -- since __submit_request() doesn't operate
> > on linger requests, there is nowhere for lreq->t.paused to be set.
> > One consequence of this is that watches don't get reestablished on
> > paused -> unpaused transitions in cases where requests have been paused
> > long enough for the (paused) unwatch request to time out and for the
> > subsequent (re)watch request to enter the paused state.  On top of the
> > watch not getting reestablished, rbd_reregister_watch() gets stuck with
> > rbd_dev->watch_mutex held:
> >
> >   rbd_register_watch
> >     __rbd_register_watch
> >       ceph_osdc_watch
> >         linger_reg_commit_wait
> >
> > It's waiting for lreq->reg_commit_wait to be completed, but for that to
> > happen the respective request needs to end up on need_resend_linger lis=
t
> > and be kicked when requests are unpaused.  There is no chance for that
> > if the request in question is never marked paused in the first place.
> >
> > The fact that rbd_dev->watch_mutex remains taken out forever then
> > prevents the image from getting unmapped -- "rbd unmap" would inevitabl=
y
> > hang in D state on an attempt to grab the mutex.
> >
> > Cc: stable@vger.kernel.org
> > Reported-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >  net/ceph/osd_client.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index 1a7be2f615dc..610e584524d1 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -1586,6 +1586,7 @@ static enum calc_target_result calc_target(struct=
 ceph_osd_client *osdc,
> >       struct ceph_pg_pool_info *pi;
> >       struct ceph_pg pgid, last_pgid;
> >       struct ceph_osds up, acting;
> > +     bool should_be_paused;
> >       bool is_read =3D t->flags & CEPH_OSD_FLAG_READ;
> >       bool is_write =3D t->flags & CEPH_OSD_FLAG_WRITE;
> >       bool force_resend =3D false;
> > @@ -1654,10 +1655,16 @@ static enum calc_target_result calc_target(stru=
ct ceph_osd_client *osdc,
> >                                &last_pgid))
> >               force_resend =3D true;
> >
> > -     if (t->paused && !target_should_be_paused(osdc, t, pi)) {
> > -             t->paused =3D false;
> > +     should_be_paused =3D target_should_be_paused(osdc, t, pi);
> > +     if (t->paused && !should_be_paused) {
>
> Do we need dout() message here as symmetric to the added one?

No -- the value of unpaused is already logged before returning.

Thanks,

                Ilya

