Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F04162A46
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Feb 2020 17:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgBRQVe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 11:21:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22984 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726411AbgBRQVe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Feb 2020 11:21:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582042893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dhwDqkXAqibIeRlWP/9p15Vx9E7FOTQAMHXvr5lEz5c=;
        b=B0l8Sqmk1UE1OcKaG5XdKBdBiV5+yrEq/9s7MDNuux/+KXEr9fBqkTKiPfLGlM7AWKFsG6
        2dx2BPuD9XOV7OnUoX95BISN/MbM6TSWP9vTgfe7IEAppv+7+kDRrfo72fMkXfVSKixJoF
        GLb1ItuFR11NlvVs5E6DOKk3PnvmrWw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-gNbm2R7rMGSlJ-ACZOh7_A-1; Tue, 18 Feb 2020 11:21:30 -0500
X-MC-Unique: gNbm2R7rMGSlJ-ACZOh7_A-1
Received: by mail-qv1-f69.google.com with SMTP id cn2so12732674qvb.1
        for <ceph-devel@vger.kernel.org>; Tue, 18 Feb 2020 08:21:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dhwDqkXAqibIeRlWP/9p15Vx9E7FOTQAMHXvr5lEz5c=;
        b=nthMNk+QBfiFb/Hbj+ZgHdhkwMO5wXfuPGi9oPCAMawgO5RhdmRGC6Ze1bnYaXx7zI
         lOusSx+of3QwH7EyMZiJx43HA3iWPiGJOLCF8qQdJTx9cJOzjkDjW2SQwlKoMkNi3BUd
         3eRsgXUpfwlflqgXCgphzvrR9rMH8ROz7rhrXparq4NjDtozdHPecpckqsJYEHAnbgUb
         dlcmW6Jbx8DbfNjpUUxtNvufBwR95PNKk6gOyDYqVIC9OjRWLzLYNuDVg5RIhBaAuqZp
         Ra4h/FhNEI+IH4RdA6dQBIeh+0F1r0nyg2aLEb+/TPN/N7Tjj2JCKx/U5Tp5JNN1r3gt
         VDmA==
X-Gm-Message-State: APjAAAVbVwceknArjUNoKCJ9kriK2hIz/96y+ca+bsHXvl0vQEPHarTy
        fgckJBwDafXx0+Fb1TNsscPf1TMByTiBr+OcpNGo9vVgy21Cu08BfTMbbpO59S0xoc5FnysYIMj
        fG/npwSxckI3ucjsqKbxs67KeTesV73uXwwft2w==
X-Received: by 2002:a37:7245:: with SMTP id n66mr20718335qkc.202.1582042890399;
        Tue, 18 Feb 2020 08:21:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqxV6Krmc7whN0w0Ybnhs29HJRn5qsp1A//xvxNl5WSteDg9wRGgR5Dqcq7RMTwRXp2LfHHVSKCSWC1Uz3J36tE=
X-Received: by 2002:a37:7245:: with SMTP id n66mr20718278qkc.202.1582042889958;
 Tue, 18 Feb 2020 08:21:29 -0800 (PST)
MIME-Version: 1.0
References: <CAMMFjmE4wyKcP0KkudhTu2zeZF+SswZ=kN_k-Xaq1aC6o4vWkQ@mail.gmail.com>
 <CAMMFjmGOqAoBYmmFOWFHTw9NrGQEwNLeUPmw2+5RE+LzVMsuYw@mail.gmail.com> <alpine.DEB.2.21.2002142006120.18815@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.21.2002142006120.18815@piezo.novalocal>
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Tue, 18 Feb 2020 08:21:18 -0800
Message-ID: <CAMMFjmExNzhWDwRNfYkrmJf45p=z1fc+v00nfr=KVx6wmCDnSA@mail.gmail.com>
Subject: Re: FYI nautilus branch is locked
To:     Sage Weil <sweil@redhat.com>
Cc:     dev@ceph.io, "Development, Ceph" <ceph-devel@vger.kernel.org>,
        Abhishek Lekshmanan <abhishek@suse.com>,
        Nathan Cutler <ncutler@suse.cz>,
        Casey Bodley <cbodley@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Neha Ojha <nojha@redhat.com>,
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

Sage, I am resuming QE validation as
https://github.com/ceph/ceph/pull/33339 merged

On Fri, Feb 14, 2020 at 12:07 PM Sage Weil <sweil@redhat.com> wrote:
>
> Just a note, we need to sort out the mimic->nautilus upgrade failure
> before getting too far along here
>
>
>
>
> On Fri, 14 Feb 2020, Yuri Weinstein wrote:
>
> > Sorry correction again - 14.2.8
> >
> > On Fri, Feb 14, 2020 at 11:30 AM Yuri Weinstein <yweinste@redhat.com> wrote:
> > >
> > > We are getting ready to test 14.2.9 and nautilus branch is locked for
> > > merges until it's done.
> > >
> > > sah1 - 4d5b84085009968f557baaa4209183f1374773cd
> > >
> > > Nathan, Abhishek pls confirm.
> > >
> > > Thank you
> > > YuriW
> > _______________________________________________
> > Dev mailing list -- dev@ceph.io
> > To unsubscribe send an email to dev-leave@ceph.io
> >
> >
>

