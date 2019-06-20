Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8B54D49E
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 19:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731733AbfFTRLy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 13:11:54 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37531 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbfFTRLx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jun 2019 13:11:53 -0400
Received: by mail-qt1-f196.google.com with SMTP id y57so3966850qtk.4
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2019 10:11:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PFOEr4mJNUFAjpwMEUZAdaUsxWw4Vuz6vgIVqysI3/k=;
        b=X5lDkloOVL4VzakDX9K1Bu1hCfdNjL147YQEJfbz05S8oDaiDH2xAUSJq7FW5TZLCO
         J2Ha+iZk30vypuxFEXLgA8Z1gKejgcZewdGYldi1k5CW7ywY2Op8PzKe3GNOTkoF0FCg
         xqKHU355t5Ubwjh7cArc+NzrkN/uN0OFrnRVN91gL/WcU+LuPwHGHKQbZYcAwi5O/Fmd
         6zrnvU1ptt7c2eGVPdsQE9YNCNnbbZnQ6S/FGNqi6MCN4EpTpiyG/sfzFJe1311qO+4u
         QYlbY6sG3ttUURlG+NuHzi6KidBXgaJs7qEWUklFdcLkioMKtL9MVyCUM3DzsDvEBjvK
         WY3g==
X-Gm-Message-State: APjAAAWB+9hJPa3+Qda70UQe/3fN9PoWfi5Txzf05ulyUVohwXwCSkid
        eSokNBkni+9rAZUVGpd2eB1nV+QTQJSOjapiuXpoJA==
X-Google-Smtp-Source: APXvYqxGvOr3V1t+A3oOqVoi0oQfcFCKbF/VODV/8td73uV2Ai4+p0IBR6c36SB9N2A1rG5I3N9FTBppB+s0qxmdpgk=
X-Received: by 2002:a0c:c164:: with SMTP id i33mr41592925qvh.37.1561050712885;
 Thu, 20 Jun 2019 10:11:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190617125529.6230-1-zyan@redhat.com> <20190617125529.6230-5-zyan@redhat.com>
 <86f838f18f0871d6c21ae7bfb97541f1de8d918f.camel@redhat.com>
 <3b0a4024-d47e-0a3f-48ca-0f1f657e9da9@redhat.com> <e220f9e72b736141c39da52eb7d8d00b97a2c040.camel@redhat.com>
 <CAAM7YAmaQ6eC_zcC7xFr9c6XMOsJvR=TFXZ__i_+jnxQf5MmtA@mail.gmail.com> <03262ecae2386444d50571484fbe21592d4d3f95.camel@redhat.com>
In-Reply-To: <03262ecae2386444d50571484fbe21592d4d3f95.camel@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 20 Jun 2019 10:11:26 -0700
Message-ID: <CA+2bHPa=iuu5P8jOCGxXz7iksHXNQsmioQ_DacrhC-UgY0oDEQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] ceph: allow remounting aborted mount
To:     Jeff Layton <jlayton@redhat.com>
Cc:     "Yan, Zheng" <ukernel@gmail.com>, "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 20, 2019 at 8:34 AM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Wed, 2019-06-19 at 08:24 +0800, Yan, Zheng wrote:
> > On Tue, Jun 18, 2019 at 6:39 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > On Tue, 2019-06-18 at 14:25 +0800, Yan, Zheng wrote:
> > > > On 6/18/19 1:30 AM, Jeff Layton wrote:
> > > > > On Mon, 2019-06-17 at 20:55 +0800, Yan, Zheng wrote:
> > > > > > When remounting aborted mount, also reset client's entity addr.
> > > > > > 'umount -f /ceph; mount -o remount /ceph' can be used for recovering
> > > > > > from blacklist.
> > > > > >
> > > > >
> > > > > Why do I need to umount here? Once the filesystem is unmounted, then the
> > > > > '-o remount' becomes superfluous, no? In fact, I get an error back when
> > > > > I try to remount an unmounted filesystem:
> > > > >
> > > > >      $ sudo umount -f /mnt/cephfs ; sudo mount -o remount /mnt/cephfs
> > > > >      mount: /mnt/cephfs: mount point not mounted or bad option.
> > > > >
> > > > > My client isn't blacklisted above, so I guess you're counting on the
> > > > > umount returning without having actually unmounted the filesystem?
> > > > >
> > > > > I think this ought to not need a umount first. From a UI standpoint,
> > > > > just doing a "mount -o remount" ought to be sufficient to clear this.
> > > > >
> > > > This series is mainly for the case that mount point is not umountable.
> > > > If mount point is umountable, user should use 'umount -f /ceph; mount
> > > > /ceph'. This avoids all trouble of error handling.
> > > >
> > >
> > > ...
> > >
> > > > If just doing "mount -o remount", user will expect there is no
> > > > data/metadata get lost.  The 'mount -f' explicitly tell user this
> > > > operation may lose data/metadata.
> > > >
> > > >
> > >
> > > I don't think they'd expect that and even if they did, that's why we'd
> > > return errors on certain operations until they are cleared. But, I think
> > > all of this points out the main issue I have with this patchset, which
> > > is that it's not clear what problem this is solving.
> > >
> > > So: client gets blacklisted and we want to allow it to come back in some
> > > fashion. Do we expect applications that happened to be accessing that
> > > mount to be able to continue running, or will they need to be restarted?
> > > If they need to be restarted why not just expect the admin to kill them
> > > all off, unmount and remount and then start them back up again?
> > >
> >
> > The point is let users decide what to do. Some user values
> > availability over consistency. It's inconvenient to kill all
> > applications that use the mount, then do umount.
> >
> >
>
> I think I have a couple of issues with this patchset. Maybe you can
> convince me though:
>
> 1) The interface is really weird.
>
> You suggested that we needed to do:
>
>     # umount -f /mnt/foo ; mount -o remount /mnt/foo
>
> ...but what if I'm not really blacklisted? Didn't I just kill off all
> the calls in-flight with the umount -f? What if that umount actually
> succeeds? Then the subsequent remount call will fail.
>
> ISTM, that this interface (should we choose to accept it) should just
> be:
>
>     # mount -o remount /mnt/foo
>
> ...and if the client figures out that it has been blacklisted, then it
> does the right thing during the remount (whatever that right thing is).

This looks reasonable to me. It's not clear to me (without poring over
the code which I lack time to do rigorously) why the umount should be
necessary at all.

Furthermore, I don't like that this is requiring operator intervention
(i.e. remount) of any kind to recover the mount. If undesirable
consistency/cache coherency concerns are what's stopping us from
automatic recovery, then I propose we make client recovery
configurable with mount options and sensible defaults. For example,
the default might be to cause all open file handles to return EIO for
any operation. (Would such a thing even be easily doable within the
Linux kernel? It's not clear to me if Linux file system drivers can
somehow invalidate application file handles in this way.)

Another config option would be to allow file open for reading to
continue functioning but disable files open for writing (and drop all
buffered dirty pages).

Finally: another config to require operator to remount the file system.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
