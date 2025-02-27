Return-Path: <ceph-devel+bounces-2831-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4766AA47D2F
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Feb 2025 13:15:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C19A3A716E
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Feb 2025 12:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6462F2376FC;
	Thu, 27 Feb 2025 12:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iswqIA0j"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C93722DF99
	for <ceph-devel@vger.kernel.org>; Thu, 27 Feb 2025 12:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740658259; cv=none; b=JlAuVb/AHweSfFJBQQkTqNwXBZgLRDt5VW9dpYlK8AwYXs8j7+94FDn9uHBtlKJUXYv2/8mBlvg1KawP47yf/SkS+++NZAqi8e2ohJ6FlfHL5/tgD5Y37n7bHMENHu8+ORuieRQ/DEUOUSdsQpuPE13XQRp5y73qfXxQNsOHTwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740658259; c=relaxed/simple;
	bh=aOkF1F5VMEPq7RaUIAlM3GQ8S/xjy7XnYVaX0fCj+0o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=REaLH7adav6OxiuIl4lj/V0X3mBn3zn7csqbtYbBdzKV7qwjPt2goQt6yphukvtAZnAfsL0nvmPFfnmQs4+XP/r/yuveLPBY4GnynUmOIHBYAJECta6SkYJBWvyEPnkvLOlPX8zpEmSesqJPFnDA706CrjNOdOIoVsFx4gR4Xb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iswqIA0j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740658256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tj+zakv+J1GY4l7pCZIQYpsZc+lQol4w6bSNRx+tEoc=;
	b=iswqIA0j3scIAoNi9C+ZIGqoZkhVRWPO6ErvecRffWoceWjP1NSm6MXr8IGp+8cBUd0MAp
	XNp8GVgswRgAcgQ82ccEvHVu4LXeq9EUENIiHtqEA2y8+fx+nwpb81UrDaftOvcuFzLQ1S
	kdo7L0tCqljoEnqIZ5OSJF1cE6AyIIo=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-3JQDkEDXPCGxIm6wau1-3w-1; Thu, 27 Feb 2025 07:10:53 -0500
X-MC-Unique: 3JQDkEDXPCGxIm6wau1-3w-1
X-Mimecast-MFC-AGG-ID: 3JQDkEDXPCGxIm6wau1-3w_1740658252
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-520a2b12bcaso1178693e0c.0
        for <ceph-devel@vger.kernel.org>; Thu, 27 Feb 2025 04:10:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740658252; x=1741263052;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tj+zakv+J1GY4l7pCZIQYpsZc+lQol4w6bSNRx+tEoc=;
        b=l1vSdHl+gnl8NYC/h+yfTE01lSc+89lcbbeVEisPLa3pBzyz0bXXGbHb5EZy6gxlxu
         y6mofgOASZuqvb9IEC/kayPpXy2xmiIGbiu8r7OWxC6bvz7BR/pNF61mVtJEEnn2BO5M
         5UU6pswJtALhwN7JWB9B3+vAZJHGkXZ4gofC52j2GnkK+QDUqSwsKeGrp5ocwrI7u/LH
         j5JGuEdL0bhwbyej7AO30c6ddMBG7dMddmZ8tTyUkL469r94odZ1ltEWYMnEl41eaCgF
         htCgsylWhlMmk0Nmgxzh5Rvj5y+kEnDVIUUXliwOJe5dddRRGxq7D7U7CKUlMpVJIu9p
         nk9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUZsscmxOmQ3tWQvaRDmR7XSv46s61+/NpVGZQenKkzhFXh7gk1mbbwudWYA1kPtM0KCgz+POJihF1f@vger.kernel.org
X-Gm-Message-State: AOJu0YxDLmTIMnVnhBj9LDCnNY+cQ2hcMR9qWkqt3rdBFC2T86zqIG3Z
	wlDz2Xvg6gv5kNk23MAw3mxzXn8RFGhmbpR1kPAX4K8MwTOxk9xWodQX6uHSFwJ91iKEroE5UC8
	II/fG08Z5xpAYoETiG3SBQlh4bInCbMAEAe26B5yJYBalrlCtRgZ/UtLqBoPNH3AYAx9pqEiQM+
	NoJemSVbDjkbLgKEaMBvbDEIwYg373LLTZbw==
X-Gm-Gg: ASbGncuWm7rOKGFQmbhjXPAaDq/EaNOWR59oueXWVtsLEU7qIrfXu0vyP1PS0ijR2GS
	FzrDLIyvWHHTr50MXoaya/IqEgwSipwoKEOh7/GxtT5AU52Ob04pJzBt3Z2mBQ6YyaaGj5s5K
X-Received: by 2002:a05:6122:3718:b0:518:8753:34b0 with SMTP id 71dfb90a1353d-523496045cbmr1334331e0c.4.1740658252502;
        Thu, 27 Feb 2025 04:10:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGJGa17hbL3NkPz5zxBEjKMW01JMqo4QqOpmITYprMDbHfl+cq1RqpIucpb1ERVN7ENLR2AbHoL2HW+HIuMFCw=
X-Received: by 2002:a05:6122:3718:b0:518:8753:34b0 with SMTP id
 71dfb90a1353d-523496045cbmr1334302e0c.4.1740658252180; Thu, 27 Feb 2025
 04:10:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250226190515.314845-1-slava@dubeyko.com> <3148392.1740657038@warthog.procyon.org.uk>
In-Reply-To: <3148392.1740657038@warthog.procyon.org.uk>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 27 Feb 2025 14:10:41 +0200
X-Gm-Features: AQ5f1Jpf1zukiRVhFjsTvRIc8-aq_RzDevwcME4IdutZG887rGmJUl8WZQfB-M4
Message-ID: <CAO8a2ShC4x+f1y5xUyQLCSzLrTnDWK_z4a6dpm6KaeXnVZKqMQ@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix slab-use-after-free in have_mon_and_osd_map()
To: David Howells <dhowells@redhat.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, ceph-devel@vger.kernel.org, idryomov@gmail.com, 
	linux-fsdevel@vger.kernel.org, pdonnell@redhat.com, Slava.Dubeyko@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

That's something I asked for and Slava and I discussed.
In a complex system it just makes things tidier, and things explode
earlier when not working as planned.

On Thu, Feb 27, 2025 at 1:50=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Viacheslav Dubeyko <slava@dubeyko.com> wrote:
>
> > This patch fixes the issue by means of locking
> > client->osdc.lock and client->monc.mutex before
> > the checking client->osdc.osdmap and
> > client->monc.monmap.
>
> You've also added clearance of a bunch of pointers into destruction and e=
rror
> handling paths (can I recommend you mention it in the commit message?).  =
Is
> that a "just in case" thing?  It doesn't look like the client can get
> resurrected afterwards, but I may have missed something.  If it's not jus=
t in
> case, does the access and clearance of the pointers need wrapping in the
> appropriate lock?
>
> > --- a/net/ceph/debugfs.c
> > +++ b/net/ceph/debugfs.c
> > @@ -36,18 +36,20 @@ static int monmap_show(struct seq_file *s, void *p)
> >       int i;
> >       struct ceph_client *client =3D s->private;
> >
> > -     if (client->monc.monmap =3D=3D NULL)
> > -             return 0;
> > -
> > -     seq_printf(s, "epoch %d\n", client->monc.monmap->epoch);
> > -     for (i =3D 0; i < client->monc.monmap->num_mon; i++) {
> > -             struct ceph_entity_inst *inst =3D
> > -                     &client->monc.monmap->mon_inst[i];
> > -
> > -             seq_printf(s, "\t%s%lld\t%s\n",
> > -                        ENTITY_NAME(inst->name),
> > -                        ceph_pr_addr(&inst->addr));
> > +     mutex_lock(&client->monc.mutex);
> > +     if (client->monc.monmap) {
> > +             seq_printf(s, "epoch %d\n", client->monc.monmap->epoch);
> > +             for (i =3D 0; i < client->monc.monmap->num_mon; i++) {
> > +                     struct ceph_entity_inst *inst =3D
> > +                             &client->monc.monmap->mon_inst[i];
> > +
> > +                     seq_printf(s, "\t%s%lld\t%s\n",
> > +                                ENTITY_NAME(inst->name),
> > +                                ceph_pr_addr(&inst->addr));
> > +             }
> >       }
> > +     mutex_unlock(&client->monc.mutex);
> > +
> >       return 0;
> >  }
> >
>
> You might want to look at using RCU for this (though not necessarily as p=
art
> of this fix).
>
> Apart from that:
>
> Reviewed-by: David Howells <dhowells@redhat.com>
>
> David
>


