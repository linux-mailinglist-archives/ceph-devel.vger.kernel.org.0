Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3183637FDB
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 23:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfFFVsT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jun 2019 17:48:19 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:41397 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfFFVsT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 Jun 2019 17:48:19 -0400
Received: by mail-qk1-f171.google.com with SMTP id c11so41262qkk.8
        for <ceph-devel@vger.kernel.org>; Thu, 06 Jun 2019 14:48:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d1ReP9slXEvMvpn9ZExRiRjPEPgfC/ctsSD3Hmji57Y=;
        b=dpGcJO7rp02lgWgzM0qwJ2CJ45DKvCq3TbGFdWcUshMSXhiZ5Rz/CiLWwrFKlmk5bo
         4UjUVV27h77CyxWzvrn59CozvK715A5hRBhq/O+w7gxHDSiQ9fVDAOXPO4A50/ka7GuV
         vMw3gu/tWIbx3t8SV+yck1Uetd77rXUHGJuPH89t2dzYG+zjHNMmU4XPz5M+45axtbBx
         /7LOjuUXfHeBIN3zRCpgYUT3YtKBM5vw2m8GN2mu2uNVmtDcaCHbCwLz8VIfR/0hLGga
         ZDcqXXW2pbH6evlxyBwwlgX06rGZcvTYZ1p4cyqCEj+1nBRdPCdu5OQe4wSdGJDXVmSO
         wRyw==
X-Gm-Message-State: APjAAAVoYqKN4A9K+F+peyaZp1hhLdfQfOMUN4FBrTT4WDfML9FZveT3
        oUS2uwYy0AhuEekzFSbzi9npnuk+McAEiocaTLTCxDQL
X-Google-Smtp-Source: APXvYqyfRPcW2DzwRm3R6nxKSjz/V2I/I1a85RHr4lRPezvrqj7jq8xDjiJdXDA149H01Bb+7f6EzUs/QDNJPpLBopY=
X-Received: by 2002:ae9:ed0a:: with SMTP id c10mr39949017qkg.207.1559857698336;
 Thu, 06 Jun 2019 14:48:18 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1906061434200.13706@piezo.novalocal> <alpine.DEB.2.11.1906062131180.12100@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.11.1906062131180.12100@piezo.novalocal>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 6 Jun 2019 14:47:51 -0700
Message-ID: <CA+2bHPYuUqHJn32u7grUstX1SNcrNjjuvPetgWVCzNCg=ci8Ew@mail.gmail.com>
Subject: Re: octopus planning calls
To:     Sage Weil <sage@newdream.net>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 6, 2019 at 2:36 PM Sage Weil <sage@newdream.net> wrote:
>
> On Thu, 6 Jun 2019, Sage Weil wrote:
> > Hi everyone,
> >
> > We'd like to do some planning calls for octopus.  Each call would be 30-60
> > minutes, and cover (at least) rados, rbd, rgw, and cephfs.  The dashboard
> > team has a face to face meeting next week in Germany so they should be in
> > good shape.  Sebastian, do we need to schedule something on the
> > orchestrator, or just rely on the existing Monday call?
> >
> > 1- Does the 1500-1700 UTC time range work well enough for everyone?  We'll
> > record the calls, of course, and send an email summary after.
> >
> > 2- What day(s):
> >
> >  Tomorrow (Friday Jun 7)
> >  Next week (Jun 10-14... may conflict with dashboard f2f)
>
> It seems SUSE's storage team offsite runs through tomorrow, and Monday is
> a holiday in Germany, so let's wait until next week.
>
> How about:
>
> Tue Jun 11:
>   1500 UTC  Orchestrator (Sebastian is already planning a call)
>   1600 UTC  RADOS
> Wed Jun 12:
>   1500 UTC  RBD
>   1600 UTC  RGW
> Thu Jun 13:
>   1600 UTC  CephFS

+1


-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
