Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6C3B4DF3C
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Jun 2019 04:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbfFUC7e (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 22:59:34 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45413 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfFUC7e (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jun 2019 22:59:34 -0400
Received: by mail-qk1-f196.google.com with SMTP id s22so3392065qkj.12
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2019 19:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LWyKy0GUN9A/ZNrEh1LUJ4yX/rIce3U0tKJIDfIfuCA=;
        b=LfEp2/YT1SdFf4U10nSxzkzS76cxl/5FGpfgHAAfFMslGIXVWKiqbn1dFjSBxUv3ac
         if7higmx40eRG6xsnN1VUFCRIi2UfbUT4Ds1t187BiyYQGyZwyt/DxymytUm6LN5YG6j
         ijk90vBSskeIK/i+2CVeuavY+PcfzCgKeIRaU0PPyIoABDEDsGzr++00RHHnlSJlTDXV
         Ka3xQSKK23x/3w/Gkn5dnSNiooqNCAfqDTn0TY0YyQP6NOa2ZXa9/p6/oK7i5zYeyoSd
         XgsSgzN0c48CqOgqfjGMKWrAy4flM+c9ZIID+ml/CksOXdj46rXlFcrga+7tGYtg23Nq
         VlTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LWyKy0GUN9A/ZNrEh1LUJ4yX/rIce3U0tKJIDfIfuCA=;
        b=A4g46Qlg98oS3o2kVtViOPQvG3GL2OkbBSEQz6p174hiAHtOKBdgDTtIDH2YK4/+cL
         3FLKZM5as0EtFsUkFF7/yShBIIv8lUzzarwLBSQ8yEftmFFHe3DwruRq0fM2R4WSFakm
         EbBJ999lwrIA5adS0eOmuPYiSo5UbqsXww8P7AdacvDXKKApmWj62Euv7RJGrCbpUcMS
         4QmDW5LEG1sQbCkJ2og6CWTMkJIWcmw92v2RxMPZvYukOZffx/I0Nb8OKWEvfJmobXv0
         0I3h///Bio9rVrXmscQGi3eWl4hC+QU2eMDmuG7niycnIVjhqQtoosyBm3OTwbf6IIfw
         8R3A==
X-Gm-Message-State: APjAAAWJdlOiuanUeIFdGInQV9DPmzFvnBPL7vdYq0JL4ufHT+Ng0B+n
        Gbi7YfZJvRuNDPZihUJIMB0sP22166KFZA21Kyw=
X-Google-Smtp-Source: APXvYqxB26VgMhht54fiOkQgYbk5QGsYNg45zZAvn0U/q7E80EEPSkIlsNR2EHtSXegbjiZTSIvGoXKvSyMfeFMRmhs=
X-Received: by 2002:ae9:ebd0:: with SMTP id b199mr15404031qkg.56.1561085972825;
 Thu, 20 Jun 2019 19:59:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190617125529.6230-1-zyan@redhat.com> <20190617125529.6230-5-zyan@redhat.com>
 <86f838f18f0871d6c21ae7bfb97541f1de8d918f.camel@redhat.com>
 <3b0a4024-d47e-0a3f-48ca-0f1f657e9da9@redhat.com> <e220f9e72b736141c39da52eb7d8d00b97a2c040.camel@redhat.com>
 <CAAM7YAmaQ6eC_zcC7xFr9c6XMOsJvR=TFXZ__i_+jnxQf5MmtA@mail.gmail.com>
 <03262ecae2386444d50571484fbe21592d4d3f95.camel@redhat.com> <CA+2bHPa=iuu5P8jOCGxXz7iksHXNQsmioQ_DacrhC-UgY0oDEQ@mail.gmail.com>
In-Reply-To: <CA+2bHPa=iuu5P8jOCGxXz7iksHXNQsmioQ_DacrhC-UgY0oDEQ@mail.gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 21 Jun 2019 10:59:20 +0800
Message-ID: <CAAM7YAk+TpFpGeYUV4KkDAkNRdhb-yzfR=oLBnj93dgRm+KjNA@mail.gmail.com>
Subject: Re: [PATCH 4/8] ceph: allow remounting aborted mount
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 21, 2019 at 1:11 AM Patrick Donnelly <pdonnell@redhat.com> wrote:
>
> On Thu, Jun 20, 2019 at 8:34 AM Jeff Layton <jlayton@redhat.com> wrote:
> >
> > On Wed, 2019-06-19 at 08:24 +0800, Yan, Zheng wrote:
> > > On Tue, Jun 18, 2019 at 6:39 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > On Tue, 2019-06-18 at 14:25 +0800, Yan, Zheng wrote:
> > > > > On 6/18/19 1:30 AM, Jeff Layton wrote:
> > > > > > On Mon, 2019-06-17 at 20:55 +0800, Yan, Zheng wrote:
> > > > > > > When remounting aborted mount, also reset client's entity addr.
> > > > > > > 'umount -f /ceph; mount -o remount /ceph' can be used for recovering
> > > > > > > from blacklist.
> > > > > > >
> > > > > >
> > > > > > Why do I need to umount here? Once the filesystem is unmounted, then the
> > > > > > '-o remount' becomes superfluous, no? In fact, I get an error back when
> > > > > > I try to remount an unmounted filesystem:
> > > > > >
> > > > > >      $ sudo umount -f /mnt/cephfs ; sudo mount -o remount /mnt/cephfs
> > > > > >      mount: /mnt/cephfs: mount point not mounted or bad option.
> > > > > >
> > > > > > My client isn't blacklisted above, so I guess you're counting on the
> > > > > > umount returning without having actually unmounted the filesystem?
> > > > > >
> > > > > > I think this ought to not need a umount first. From a UI standpoint,
> > > > > > just doing a "mount -o remount" ought to be sufficient to clear this.
> > > > > >
> > > > > This series is mainly for the case that mount point is not umountable.
> > > > > If mount point is umountable, user should use 'umount -f /ceph; mount
> > > > > /ceph'. This avoids all trouble of error handling.
> > > > >
> > > >
> > > > ...
> > > >
> > > > > If just doing "mount -o remount", user will expect there is no
> > > > > data/metadata get lost.  The 'mount -f' explicitly tell user this
> > > > > operation may lose data/metadata.
> > > > >
> > > > >
> > > >
> > > > I don't think they'd expect that and even if they did, that's why we'd
> > > > return errors on certain operations until they are cleared. But, I think
> > > > all of this points out the main issue I have with this patchset, which
> > > > is that it's not clear what problem this is solving.
> > > >
> > > > So: client gets blacklisted and we want to allow it to come back in some
> > > > fashion. Do we expect applications that happened to be accessing that
> > > > mount to be able to continue running, or will they need to be restarted?
> > > > If they need to be restarted why not just expect the admin to kill them
> > > > all off, unmount and remount and then start them back up again?
> > > >
> > >
> > > The point is let users decide what to do. Some user values
> > > availability over consistency. It's inconvenient to kill all
> > > applications that use the mount, then do umount.
> > >
> > >
> >
> > I think I have a couple of issues with this patchset. Maybe you can
> > convince me though:
> >
> > 1) The interface is really weird.
> >
> > You suggested that we needed to do:
> >
> >     # umount -f /mnt/foo ; mount -o remount /mnt/foo
> >
> > ...but what if I'm not really blacklisted? Didn't I just kill off all
> > the calls in-flight with the umount -f? What if that umount actually
> > succeeds? Then the subsequent remount call will fail.
> >
> > ISTM, that this interface (should we choose to accept it) should just
> > be:
> >
> >     # mount -o remount /mnt/foo
> >
> > ...and if the client figures out that it has been blacklisted, then it
> > does the right thing during the remount (whatever that right thing is).
>
> This looks reasonable to me. It's not clear to me (without poring over
> the code which I lack time to do rigorously) why the umount should be
> necessary at all.
>
> Furthermore, I don't like that this is requiring operator intervention
> (i.e. remount) of any kind to recover the mount. If undesirable
> consistency/cache coherency concerns are what's stopping us from
> automatic recovery,

if admin want clients to auto recover. why enabling blacklist on eviction
at the first place.

> then I propose we make client recovery
> configurable with mount options and sensible defaults. For example,
> the default might be to cause all open file handles to return EIO for
> any operation. (Would such a thing even be easily doable within the
> Linux kernel? It's not clear to me if Linux file system drivers can
> somehow invalidate application file handles in this way.)
>

> Another config option would be to allow file open for reading to
> continue functioning but disable files open for writing (and drop all
> buffered dirty pages).
>
> Finally: another config to require operator to remount the file system.
>
> --
> Patrick Donnelly, Ph.D.
> He / Him / His
> Senior Software Engineer
> Red Hat Sunnyvale, CA
> GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
