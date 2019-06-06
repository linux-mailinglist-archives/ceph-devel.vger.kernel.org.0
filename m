Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFEBE38007
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 23:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbfFFVys (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jun 2019 17:54:48 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:33113 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728767AbfFFVys (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 Jun 2019 17:54:48 -0400
Received: by mail-wr1-f47.google.com with SMTP id n9so168025wru.0
        for <ceph-devel@vger.kernel.org>; Thu, 06 Jun 2019 14:54:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZtQl7uGpwXT+4UvO84d/cBzMuV2VKLIYdpiWHt1BAbc=;
        b=OHGgkN1zKa/AJ5sV5a5jVfWTvQJBg2ACDreE1GN0uEhC+mzIeODKjjO+MY7rZE3rlq
         62cbJh2vdtn/yA2wkNK8cke3vpFIjKSBWDjBwe+O30DglERGfUStpZmovf5uDybImX59
         5nt2m2ryWXU0NkiONOQgnMRB2/x7lntdt2cSDl8cG+eYxTPDHlNGvRqyAYpvRlAf3OP6
         zb71gIWtL1QVO4OEz32ECeqCePqMsUGFdQl7U9UB1Q02XhTT75LZlEypAJruBiMcu7Ga
         G7BSWtVWwHka8FAeMIabibthWyBwjqzBp3TfxIQJKIiUaYck+J1Qf9Tk3qKvtlK8ZLjX
         2WYQ==
X-Gm-Message-State: APjAAAWzGZHowh+aMr/05yJJKrkwsJwS/5Ts+uFn11rj96vPci0W7DnS
        Llg6ByA6pUc5nub1EvTNteKkMzjmYruFP4xKzfUEjQ==
X-Google-Smtp-Source: APXvYqxw0lAb7aAN8zUiVEaccaFo6L0TfyqrHK+29KMaOpUWlxlM57mmXfNvNMJChvVSAlsxm7wzlEYSJkbeZsvix8A=
X-Received: by 2002:a5d:4310:: with SMTP id h16mr18838812wrq.331.1559858086831;
 Thu, 06 Jun 2019 14:54:46 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1906061434200.13706@piezo.novalocal>
 <alpine.DEB.2.11.1906062131180.12100@piezo.novalocal> <CA+2bHPYuUqHJn32u7grUstX1SNcrNjjuvPetgWVCzNCg=ci8Ew@mail.gmail.com>
In-Reply-To: <CA+2bHPYuUqHJn32u7grUstX1SNcrNjjuvPetgWVCzNCg=ci8Ew@mail.gmail.com>
From:   Ali Maredia <amaredia@redhat.com>
Date:   Thu, 6 Jun 2019 17:54:20 -0400
Message-ID: <CAFTo4zq08PK5_MY4V88WhwXZ3gjGpBkN+ksiWiEkZE84ntJ7JQ@mail.gmail.com>
Subject: Re: octopus planning calls
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Sage Weil <sage@newdream.net>,
        Ceph Development <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Sage,

Are these meetings going to get added to the Ceph Community calendar?

Best,
Ali

On Thu, Jun 6, 2019 at 5:49 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
>
> On Thu, Jun 6, 2019 at 2:36 PM Sage Weil <sage@newdream.net> wrote:
> >
> > On Thu, 6 Jun 2019, Sage Weil wrote:
> > > Hi everyone,
> > >
> > > We'd like to do some planning calls for octopus.  Each call would be 30-60
> > > minutes, and cover (at least) rados, rbd, rgw, and cephfs.  The dashboard
> > > team has a face to face meeting next week in Germany so they should be in
> > > good shape.  Sebastian, do we need to schedule something on the
> > > orchestrator, or just rely on the existing Monday call?
> > >
> > > 1- Does the 1500-1700 UTC time range work well enough for everyone?  We'll
> > > record the calls, of course, and send an email summary after.
> > >
> > > 2- What day(s):
> > >
> > >  Tomorrow (Friday Jun 7)
> > >  Next week (Jun 10-14... may conflict with dashboard f2f)
> >
> > It seems SUSE's storage team offsite runs through tomorrow, and Monday is
> > a holiday in Germany, so let's wait until next week.
> >
> > How about:
> >
> > Tue Jun 11:
> >   1500 UTC  Orchestrator (Sebastian is already planning a call)
> >   1600 UTC  RADOS
> > Wed Jun 12:
> >   1500 UTC  RBD
> >   1600 UTC  RGW
> > Thu Jun 13:
> >   1600 UTC  CephFS
>
> +1
>
>
> --
> Patrick Donnelly, Ph.D.
> He / Him / His
> Senior Software Engineer
> Red Hat Sunnyvale, CA
> GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
