Return-Path: <ceph-devel+bounces-2870-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C4BBA54CC4
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Mar 2025 14:59:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C68E3A2513
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Mar 2025 13:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D1413D244;
	Thu,  6 Mar 2025 13:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K4fRJfx6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462E113DDAE
	for <ceph-devel@vger.kernel.org>; Thu,  6 Mar 2025 13:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741269568; cv=none; b=H+oQlylqxMWqDZRpcailSfWQeHVEctuUJNdmLQCxf2miesdvsOYU8jwgmrMeEF4YOOTR1l4G473Qgg2YeEJcwN1amo6/OgZAjzLgeNe3x0WCysbbzuEvkTliwWK7sAufPs983w70lemKQWEGzULbnkCpzZeIuWrN30EYy0lTddU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741269568; c=relaxed/simple;
	bh=WrqtzWC0xwvi6F9AT2fXYa95OcNU+FznHVE/qmwTd54=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sYGBQ8WuUz6sLRoMGpJ+xf6Xi05o2L8Rs4yDnZpLmuy1XcvbJa080jt673w8VBSdN4zbfCzm220VnSta2fp5Vk1llfClWOjmFDCRqOTK9QRXBOqrUCaM1MshiwdArRPHKa1YlkrbgCLffAmdElgLuZCnhMPK5Khl1sicXnZEML4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K4fRJfx6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741269566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZooRQX1BKvmOK4sDMN2bxn8s21u0gT4SA35hpx5Jgms=;
	b=K4fRJfx6Y07Tp1F/xn7L7G/mjXRnmD6bDOfYXd1YPof34DL6zhwrGp254Q4aXfy321faCJ
	MMp3YDs7fRzbBC5tlTJke7jp1sutJU2Twm9zS41j5d7rlYPgMJ9TE566+N7MDlLB3Cv/uH
	/RK50VeZsglgwrADqduE6m5gjchvBgY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-NsysAfhePfC03uUgwzGH9A-1; Thu, 06 Mar 2025 08:59:25 -0500
X-MC-Unique: NsysAfhePfC03uUgwzGH9A-1
X-Mimecast-MFC-AGG-ID: NsysAfhePfC03uUgwzGH9A_1741269564
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5e4b6eba254so609661a12.3
        for <ceph-devel@vger.kernel.org>; Thu, 06 Mar 2025 05:59:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741269564; x=1741874364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZooRQX1BKvmOK4sDMN2bxn8s21u0gT4SA35hpx5Jgms=;
        b=k1G+Nn2DdSaij7huYdRC+Tq2EedpxNlrlopt7mmRthRAi+Yfo9RIj1g3Nux/gT6eWB
         bNwEdUWAhZu20hKIbTXRYLDPqr+cDOxWSoaM4m/gTP0SwKIsA/iAy/Se0WXEqEqyRKiW
         /0Jz+ZoD+C8ehXObiGfzMNzThdJqXBU8IuuSScxJCAmdyvJvAVPsTQpvNr64BMlRdkLZ
         pX1rEb5rHtbADComX+7vNzER3OaM3UAlTdPe53TLWMT7xoAFzCMO3dF0kPXKSDNstHOl
         z7VrjqMel9YOuqsj+wxMZ50VnlUTSPFPq/u2cOlvODiERLJ5ggRI5ij6X2+ma6D9cdGl
         oZAw==
X-Forwarded-Encrypted: i=1; AJvYcCXbUaEZHes2HNACMg5wfV7PiUOkYqtdjsGQ5M2dOluKLjfPp+f8DbyqpqO0DKW/7+x1hSl1h5D9H7OH@vger.kernel.org
X-Gm-Message-State: AOJu0YzNZ/o+m2dL5IxzV44gxR8jBFeKvCfoXTE+RGDpO7q5Gvwdo7zH
	iDGJPN0l7WxBcREKCRIiiuMzC/AD5+8jNa1tQZNvwg38vpclihG4JRzJCnYz2c2ccFS854ml7aK
	uQc7gvL9NxpDkYASZDXq9EfnkHq0fgX+r6IazJmRjUqwr5qFb0o1YhqhmWcsy4ewX4WY8JgX1hJ
	Y5PDb5VKzVbmDpo3dk4sgWHL9t85vrASYw/w==
X-Gm-Gg: ASbGncuY6oyWsl4CeRgGZnO3HxVDxY9cycgnREw6vTiS0Y81oMIpQzD2Lpwgev3nvOh
	0EC0eBLUzYeSm6y0Yd7TvDx2F9VTuNONG8YNBOkN/OzyjGxYeLaXlH5BRSd73G8jM34iwmqM=
X-Received: by 2002:a17:907:3e1a:b0:abf:4e8b:73e with SMTP id a640c23a62f3a-ac20da87c3fmr775575466b.39.1741269563823;
        Thu, 06 Mar 2025 05:59:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF/M8v+9xzTHPmLpQ75OAihzQ6mzPMwQ9pLsX1TWkjNDEi6t39DvU097jtsd97RK2Ju6JSIYApTxIBWuz8YYMc=
X-Received: by 2002:a17:907:3e1a:b0:abf:4e8b:73e with SMTP id
 a640c23a62f3a-ac20da87c3fmr775572766b.39.1741269563390; Thu, 06 Mar 2025
 05:59:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3989572.1734546794@warthog.procyon.org.uk> <4170997.1741192445@warthog.procyon.org.uk>
 <CAO8a2Sg2b2nW6S3ctS+H0F1Owt=rAkKCyjnFW3WoRSKYD-sSDQ@mail.gmail.com>
In-Reply-To: <CAO8a2Sg2b2nW6S3ctS+H0F1Owt=rAkKCyjnFW3WoRSKYD-sSDQ@mail.gmail.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Thu, 6 Mar 2025 19:28:44 +0530
X-Gm-Features: AQ5f1JoxybOFaeQfOnAFb2qT6vfHxfb4ypSveZZzWheKw-_E5068fWRJzQnFOfM
Message-ID: <CACPzV1mpUUnxpKQFtDzd25NzwooQLyyzdRhxEsHKtt3qfh35mA@mail.gmail.com>
Subject: Re: Is EOLDSNAPC actually generated? -- Re: Ceph and Netfslib
To: Alex Markuze <amarkuze@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>, 
	ceph-devel@vger.kernel.org, netfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, Gregory Farnum <gfarnum@redhat.com>, 
	Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 6, 2025 at 12:54=E2=80=AFAM Alex Markuze <amarkuze@redhat.com> =
wrote:
>
> That's a good point, though there is no code on the client that can
> generate this error, I'm not convinced that this error can't be
> received from the OSD or the MDS. I would rather some MDS experts
> chime in, before taking any drastic measures.

The OSDs could possibly return this to the client, so I don't think it
can be done away with.

>
> + Greg, Venky, Patrik
>
> On Wed, Mar 5, 2025 at 6:34=E2=80=AFPM David Howells <dhowells@redhat.com=
> wrote:
> >
> > Hi Alex, Slava,
> >
> > I'm looking at making a ceph_netfs_write_iter() to handle writing to ce=
ph
> > files through netfs.  One thing I'm wondering about is the way
> > ceph_write_iter() handles EOLDSNAPC.  In this case, it goes back to
> > retry_snap and renegotiates the caps (amongst other things).  Firstly, =
does it
> > actually need to do this?  And, secondly, I can't seem to find anything=
 that
> > actually generates EOLDSNAPC (or anything relevant that generates EREST=
ART).
> >
> > Is it possible that we could get rid of the code that handles EOLDSNAPC=
?
> >
> > David
> >
>


--=20
Cheers,
Venky


