Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6D734350
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 11:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfFDJhW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 05:37:22 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:35974 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbfFDJhW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 05:37:22 -0400
Received: by mail-it1-f193.google.com with SMTP id r135so161720ith.1
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2019 02:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OG+ggMPE2/MLXRGyHC+3jYTnlM3p1GXyBcyUs7zrz8Q=;
        b=b3YXoE77bdASEHaJgYkQAxAn/ICTsnAX/PLQSlT+HCQup5tkGgCcqxadU4c+EP+H6N
         CO3gHz2rc186akXPB16l1UfoH58Q++2c/6lR+PwhutRlF/9FMR+LdbTZM+Hh/VhSvVkC
         FiJHAPcgz8b6zQH0lu1yL3gym89Wtnb11/CzR7/4v6PrI7/vEwx9ZQmWsWhL6OcE8p/o
         bFNcUMZ2++ZabDbtCJ0TgKXSk0Vl+0vd5Wu0EnzwYySVg2spqB/oDdPAxu/vbxuf7nGX
         x8iQuD6BdEuUtFmtiGMTVe3aOtCcmrCAKWH2yUFuCjtCuxD0u45alW2e7ucogOHgZ6WK
         leiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OG+ggMPE2/MLXRGyHC+3jYTnlM3p1GXyBcyUs7zrz8Q=;
        b=IYwjeJOVDaHvJ7MbYtbFbdxIrl6O4pmgv/Sq4NErVgwm72CStzK6ADlF0HIxt7KcMV
         VWxcvUVWm7lrdtI3VC6K8eKd9tmJThA1B8vs0DvSt/IryuEJ4Ah68cz6pM1ZaCzfP0vb
         CUW/p8CSnj/SDsUHI30Pr2u6ZAfePkpdztT1DYrfaCj/AjrgjYYTEOBFr5URcvQ5ART3
         ieUBMg+gnjL+3NwmH5JH0rOSlGIYCrxcFDJT/VSk3UePikhrMXLOGw+izad/og4/Fefi
         6zcYieWyrTFzYOfmMVkDirWX3GRKn/pKVrYTSBuIExoeNJinPnwLlU/qOq2kGUXBSlrp
         aXzw==
X-Gm-Message-State: APjAAAWzZsedR3s7o/SAXiVWJiHyNscreJGQRm2fOtdZdDLsHXs7qrs3
        psf+sx3gPfO4sI0K0Ju+WoG64NlCIy4BzEyMjKgOfFIG
X-Google-Smtp-Source: APXvYqxco0TsR8ExUezA+wTvoKZK8sWODvhRi2rGM81YHt9j/G92MhZo66eia4w+wuDw6qIvxOjfiqeF7Qs8fASoxmc=
X-Received: by 2002:a24:3a83:: with SMTP id m125mr19986180itm.171.1559641041863;
 Tue, 04 Jun 2019 02:37:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190531122802.12814-1-zyan@redhat.com> <20190531122802.12814-2-zyan@redhat.com>
 <CAOi1vP8O6VviiNKrozmwUOtVN+GtvA=-0fEOXcdbg8O+pu1PhQ@mail.gmail.com>
 <CAAM7YAmY-ky2E_9aPHNSNMmmTp9rC+Aw-eBMN_KP1suY_u+Wmg@mail.gmail.com>
 <CAJ4mKGZHm3TqwU8Q=rn1xQtePMhaJNvU4yHGj0jDqR_9oxz2fA@mail.gmail.com>
 <CAOi1vP8k88mFJgLYvD-zWBFgwV4vQ4DR0wBDzSDeDCDBaSLj_g@mail.gmail.com>
 <CAJ4mKGY+jhc926uSRJUtHgL174wtq_3dLO3_1ks=2kpNk9Pkaw@mail.gmail.com> <CA+2bHPboGYSY82Mh73qdSREZhzve72s4GgDVXqhdrdpW9YbC7Q@mail.gmail.com>
In-Reply-To: <CA+2bHPboGYSY82Mh73qdSREZhzve72s4GgDVXqhdrdpW9YbC7Q@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 4 Jun 2019 11:37:27 +0200
Message-ID: <CAOi1vP_QNR9u78GhJzxeiUPkq6OT7FVBP3R2u3d02F=uNN1FDw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ceph: add method that forces client to reconnect
 using new entity addr
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>, "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 3, 2019 at 11:05 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
>
> On Mon, Jun 3, 2019 at 1:24 PM Gregory Farnum <gfarnum@redhat.com> wrote:
> >
> > On Mon, Jun 3, 2019 at 1:07 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > > Can we also discuss how useful is allowing to recover a mount after it
> > > has been blacklisted?  After we fail everything with EIO and throw out
> > > all dirty state, how many applications would continue working without
> > > some kind of restart?  And if you are restarting your application, why
> > > not get a new mount?
> > >
> > > IOW what is the use case for introducing a new debugfs knob that isn't
> > > that much different from umount+mount?
> >
> > People don't like it when their filesystem refuses to umount, which is
> > what happens when the kernel client can't reconnect to the MDS right
> > now. I'm not sure there's a practical way to deal with that besides
> > some kind of computer admin intervention.
>
> Furthermore, there are often many applications using the mount (even
> with containers) and it's not a sustainable position that any
> network/client/cephfs hiccup requires a remount. Also, an application

Well, it's not just any hiccup.  It's one that lead to blacklisting...

> that fails because of EIO is easy to deal with a layer above but a
> remount usually requires grump admin intervention.

I feel like I'm missing something here.  Would figuring out $ID,
obtaining root and echoing to /sys/kernel/debug/$ID/control make the
admin less grumpy, especially when containers are involved?

Doing the force_reconnect thing would retain the mount point, but how
much use would it be?  Would using existing (i.e. pre-blacklist) file
descriptors be allowed?  I assumed it wouldn't be (permanent EIO or
something of that sort), so maybe that is the piece I'm missing...

Thanks,

                Ilya
