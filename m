Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47BBC37A85
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 19:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfFFRHW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jun 2019 13:07:22 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:41486 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFFRHW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 Jun 2019 13:07:22 -0400
Received: by mail-ed1-f53.google.com with SMTP id p15so4346793eds.8
        for <ceph-devel@vger.kernel.org>; Thu, 06 Jun 2019 10:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=I+SraFuAWeUSKKLzgqKB5fyAfwSYXn+tuN5WKPpykOc=;
        b=p0Qc2AYw8IODg5Y6zPuo4tD2r/mFIpqymBvyNRuAk+f4Ynyyvs/YDF98AGsT/h3Rdo
         Rtr4DIcyydZwlQ2jg5wY/Oih0iu3o9mz7Cvy05MHbyztAbe4dinDrA4SeincvXIMuCXM
         BcZU/BIP4j3CHP2s64tlVCvlNzJEOqIvQbpzV6SV/Wwdgh4FVF69DhsgcCCIB8tuupfo
         ftQ49FXD6C6y8ECMN+o5gxr1SD5jOB/EXKwOYhpftZLlN1k6aF8TAVcqogvDe024xe2V
         6QTxHl7HoEmUVR6tTCZIurcRoywu5ex1wgdwyvB+TtzmPIQd6LGNWJIc9IA8QMHlR4tC
         tgPg==
X-Gm-Message-State: APjAAAWYAi6kyDLle1mj89qfhFEvWg7KiEMiAJfExL/VDpV9W+wt91zn
        yR5ZMZZ7B0uL6CnLNdn6f2J8ZpgfHWX7DQXjAjLnaA==
X-Google-Smtp-Source: APXvYqwcmANKLE5UgUYBQW1orcrJG1VAAzdeN4ylxhByOgVgnTtHyhUsSaqdob7DudEbEnl73HNpgb8tqXwEI7tsZts=
X-Received: by 2002:a17:906:4694:: with SMTP id a20mr28439763ejr.67.1559840840903;
 Thu, 06 Jun 2019 10:07:20 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1906061434200.13706@piezo.novalocal> <CAKn7kB=v-uD1-5Zc7pwxm7p6xYsJra+nmiSO4LUcrtN9kOkTrQ@mail.gmail.com>
In-Reply-To: <CAKn7kB=v-uD1-5Zc7pwxm7p6xYsJra+nmiSO4LUcrtN9kOkTrQ@mail.gmail.com>
Reply-To: dillaman@redhat.com
From:   Jason Dillaman <jdillama@redhat.com>
Date:   Thu, 6 Jun 2019 13:07:08 -0400
Message-ID: <CA+aFP1BU8Mep4z=R=uYwzA9aU+V-vO3JJo9keckA+Rhpy3QHpA@mail.gmail.com>
Subject: Re: octopus planning calls
To:     Neha Ojha <nojha@redhat.com>
Cc:     Sage Weil <sweil@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 6, 2019 at 12:55 PM Neha Ojha <nojha@redhat.com> wrote:
>
> On Thu, Jun 6, 2019 at 8:15 AM Sage Weil <sweil@redhat.com> wrote:
> >
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
> >  The following week (Jun 17-21)
> >
> > If notice isn't too short for tomorrow or Monday, it might be nice to have
> > some clarity for the dashboard folks going into their f2f as far as what
> > underlying work and new features are in the pipeline.
> >
> > Maybe... RADOS and RBD tomorrow, CephFS and RGW Monday?  Is that too much
> > of a stretch?
> Tomorrow (Friday June 7) 1500-1700 UTC works for RADOS.

Fine for RBD as well.

> - Neha
> >
> > sage
> >
> _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io



-- 
Jason
