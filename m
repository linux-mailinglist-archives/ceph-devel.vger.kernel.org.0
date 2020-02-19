Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986B6163A6F
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 03:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbgBSCqX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 21:46:23 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43487 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728180AbgBSCqW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 21:46:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582080381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ipJiIcUgttythxyaQwek/E3HvXKFjz8pYTIT+47z5uw=;
        b=BKqpRM2lhrk4rdlY7f5OkcZAh/G8lqCO1y+lLKd9VKgZNSQ8qWXpRL3fGc8znXBQbXTEVV
        1HQmhQiXG3sUwJQvgMr6++FeT+4OKyeQtZNwSG5FjYHy779Sy1EciEUbe4ZjS+ue7jznhR
        +W1IuvehLwafUPhbRCz6lLe7zhfpnck=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-RxECCHRoMA-uS_AtROQyrw-1; Tue, 18 Feb 2020 21:46:15 -0500
X-MC-Unique: RxECCHRoMA-uS_AtROQyrw-1
Received: by mail-qt1-f199.google.com with SMTP id c10so14510351qtk.18
        for <ceph-devel@vger.kernel.org>; Tue, 18 Feb 2020 18:46:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ipJiIcUgttythxyaQwek/E3HvXKFjz8pYTIT+47z5uw=;
        b=PTUFl/McFsZOZWnnB42DULkmQdU4AbPv66ZHyz0Z44r/fNpCP+reJ0IsObtKnmySyn
         djjX7rr11IT2/DD9vcf87svhQvjATOZmh5F8Z9SIXJdGDV4O3iwbWUvtMNIBEDM9XKGs
         Jw1f2WCD1JHptLf+xgpt2uH5tE4FDskfv/Bkz3+dyYGhCj9NuedNwxZ42gNT4jLUrSnx
         apU7KMxKfMEgSHUsnTY9GJag+LvLEpAKtOHaciYCU8OaQRAOvhkdPUU7FVioRaO3KAQz
         fJCX9Cl/DovuInwWXusI7jnagMy7O/FK/P+0dXRSmKaNJtiKSl37Veg9XQlermqqjw1H
         Gd0g==
X-Gm-Message-State: APjAAAX91EBPFtfiHB69jMd0CaNvU780aLtUEizan1jbJIE9MR/oBZtR
        s6y+2PfFwVfnaxx7vtIYr4rsn9QfaWN+YKQktAzGXKRhEEdprXVfGDJ9qu5gQ5U5m1O9xuIQMdy
        aFdCqACjR2TXTACrM5RpSSG1jV9620oYgcdLooA==
X-Received: by 2002:ac8:530c:: with SMTP id t12mr18989918qtn.83.1582080375389;
        Tue, 18 Feb 2020 18:46:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqwiFQYKqagr02tOaMQX/hyDASknV6sLJmG8fI3zlaj5S2JAI+mFqlPduNSArAq33snxm3lA6fwNOVX1mSXP7MU=
X-Received: by 2002:ac8:530c:: with SMTP id t12mr18989911qtn.83.1582080375123;
 Tue, 18 Feb 2020 18:46:15 -0800 (PST)
MIME-Version: 1.0
References: <CAMMFjmE4wyKcP0KkudhTu2zeZF+SswZ=kN_k-Xaq1aC6o4vWkQ@mail.gmail.com>
 <CAMMFjmGOqAoBYmmFOWFHTw9NrGQEwNLeUPmw2+5RE+LzVMsuYw@mail.gmail.com>
 <alpine.DEB.2.21.2002142006120.18815@piezo.novalocal> <CAMMFjmExNzhWDwRNfYkrmJf45p=z1fc+v00nfr=KVx6wmCDnSA@mail.gmail.com>
In-Reply-To: <CAMMFjmExNzhWDwRNfYkrmJf45p=z1fc+v00nfr=KVx6wmCDnSA@mail.gmail.com>
From:   Neha Ojha <nojha@redhat.com>
Date:   Tue, 18 Feb 2020 18:46:04 -0800
Message-ID: <CAKn7kBmU50hxfVqqUzR-YJf1PJnYpGeMhDZpVpGLi_vZr2MMgA@mail.gmail.com>
Subject: Re: FYI nautilus branch is locked
To:     Yuri Weinstein <yweinste@redhat.com>
Cc:     Sage Weil <sweil@redhat.com>, dev@ceph.io,
        "Development, Ceph" <ceph-devel@vger.kernel.org>,
        Abhishek Lekshmanan <abhishek@suse.com>,
        Nathan Cutler <ncutler@suse.cz>,
        Casey Bodley <cbodley@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Durgin, Josh" <jdurgin@redhat.com>,
        David Zafman <dzafman@redhat.com>,
        Ramana Venkatesh Raja <rraja@redhat.com>,
        Tamilarasi Muthamizhan <tmuthami@redhat.com>,
        "Dillaman, Jason" <dillaman@redhat.com>,
        "Sadeh-Weinraub, Yehuda" <yehuda@redhat.com>,
        "Lekshmanan, Abhishek" <abhishek.lekshmanan@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        ceph-qe-team <ceph-qe-team@redhat.com>,
        Andrew Schoen <aschoen@redhat.com>, ceph-qa <ceph-qa@ceph.com>,
        Matt Benjamin <mbenjamin@redhat.com>,
        Sebastien Han <shan@redhat.com>,
        Brad Hubbard <bhubbard@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        David Galloway <dgallowa@redhat.com>,
        Milind Changire <mchangir@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 18, 2020 at 8:21 AM Yuri Weinstein <yweinste@redhat.com> wrote:
>
> Sage, I am resuming QE validation as
> https://github.com/ceph/ceph/pull/33339 merged

This PR fixed an upgrade bug for
octopus(https://tracker.ceph.com/issues/44156) and should not be
mistaken for https://tracker.ceph.com/issues/43048, which we continue
to investigate.

Thanks,
Neha

>
> On Fri, Feb 14, 2020 at 12:07 PM Sage Weil <sweil@redhat.com> wrote:
> >
> > Just a note, we need to sort out the mimic->nautilus upgrade failure
> > before getting too far along here
> >
> >
> >
> >
> > On Fri, 14 Feb 2020, Yuri Weinstein wrote:
> >
> > > Sorry correction again - 14.2.8
> > >
> > > On Fri, Feb 14, 2020 at 11:30 AM Yuri Weinstein <yweinste@redhat.com> wrote:
> > > >
> > > > We are getting ready to test 14.2.9 and nautilus branch is locked for
> > > > merges until it's done.
> > > >
> > > > sah1 - 4d5b84085009968f557baaa4209183f1374773cd
> > > >
> > > > Nathan, Abhishek pls confirm.
> > > >
> > > > Thank you
> > > > YuriW
> > > _______________________________________________
> > > Dev mailing list -- dev@ceph.io
> > > To unsubscribe send an email to dev-leave@ceph.io
> > >
> > >
> >
>

