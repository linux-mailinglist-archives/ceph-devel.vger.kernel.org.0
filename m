Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2D84F359
	for <lists+ceph-devel@lfdr.de>; Sat, 22 Jun 2019 05:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfFVDWI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Jun 2019 23:22:08 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43168 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFVDWH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 21 Jun 2019 23:22:07 -0400
Received: by mail-qt1-f193.google.com with SMTP id w17so8989004qto.10
        for <ceph-devel@vger.kernel.org>; Fri, 21 Jun 2019 20:22:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=orPpq74mOGfQOwA1oeEvfjIP+HLe0sKDcwtrIvzotPc=;
        b=IDXL0vRPCPv4S6Mhy6lZvuA6NKCtxj6rnj8/WjYnEU8swBAfpd6r3/bTm6723+ETgE
         +EcVcjyLvAj5yG5MoV0v7UKuykOhoDFeiMOrTlACQD0R4ZjrxQDREZxcCCkJsZ2G53Mv
         X5rXaOgkViZOXxIEcLgim36qo5BUzhrZ6ubVKoy9+yMSGekFs0IrJKVzKTfdDyLC9CCO
         ZDHdohYuZKrleKCkZg50/D0UpTIT5+JYiB4KJd3YsXqs11JcO0N5mxtPZey7TS30FUz8
         bCTmOwzjaL/L1vv6G2VSGNMHCaeyvt+2taB8p95XRZdCsTyxSgCTuM3TIY6PH56ZScJQ
         7QXQ==
X-Gm-Message-State: APjAAAVKONVRaX4PtxAYD0cERLXHVrSbHqzQZjMnVkm9OiIrdrRzxx4+
        XRSfvMVeXO4bThi1A2eKLYpU+tBrJgKW4mEKcdeyPQ==
X-Google-Smtp-Source: APXvYqyQW3rukIftumEFzl8nGtyDRJ0gN7/rD+S7w8bttZ1Oiuy7zWTFsNrSIxgKf0uxJ/oVgGjxoH9aZ6FmWiZ4luE=
X-Received: by 2002:ac8:4252:: with SMTP id r18mr23637152qtm.357.1561173727011;
 Fri, 21 Jun 2019 20:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190617125529.6230-1-zyan@redhat.com> <20190617125529.6230-5-zyan@redhat.com>
 <86f838f18f0871d6c21ae7bfb97541f1de8d918f.camel@redhat.com>
 <3b0a4024-d47e-0a3f-48ca-0f1f657e9da9@redhat.com> <e220f9e72b736141c39da52eb7d8d00b97a2c040.camel@redhat.com>
 <CAAM7YAmaQ6eC_zcC7xFr9c6XMOsJvR=TFXZ__i_+jnxQf5MmtA@mail.gmail.com>
 <03262ecae2386444d50571484fbe21592d4d3f95.camel@redhat.com> <d45fef05-5b6c-5919-fa0f-98e900c7f05b@redhat.com>
In-Reply-To: <d45fef05-5b6c-5919-fa0f-98e900c7f05b@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Fri, 21 Jun 2019 20:21:37 -0700
Message-ID: <CA+2bHPYcMiE4DszFsHDgTeOWz-kHa0RiWmdNb=PDZMkV2B6QSw@mail.gmail.com>
Subject: Re: [PATCH 4/8] ceph: allow remounting aborted mount
To:     "Yan, Zheng" <zyan@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>, "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 21, 2019 at 1:11 AM Yan, Zheng <zyan@redhat.com> wrote:
>
> On 6/20/19 11:33 PM, Jeff Layton wrote:
> > On Wed, 2019-06-19 at 08:24 +0800, Yan, Zheng wrote:
> >> On Tue, Jun 18, 2019 at 6:39 PM Jeff Layton <jlayton@redhat.com> wrote:
> >>> On Tue, 2019-06-18 at 14:25 +0800, Yan, Zheng wrote:
> >>>> On 6/18/19 1:30 AM, Jeff Layton wrote:
> >>>>> On Mon, 2019-06-17 at 20:55 +0800, Yan, Zheng wrote:
> >>>>>> When remounting aborted mount, also reset client's entity addr.
> >>>>>> 'umount -f /ceph; mount -o remount /ceph' can be used for recovering
> >>>>>> from blacklist.
> >>>>>>
> >>>>>
> >>>>> Why do I need to umount here? Once the filesystem is unmounted, then the
> >>>>> '-o remount' becomes superfluous, no? In fact, I get an error back when
> >>>>> I try to remount an unmounted filesystem:
> >>>>>
> >>>>>       $ sudo umount -f /mnt/cephfs ; sudo mount -o remount /mnt/cephfs
> >>>>>       mount: /mnt/cephfs: mount point not mounted or bad option.
> >>>>>
> >>>>> My client isn't blacklisted above, so I guess you're counting on the
> >>>>> umount returning without having actually unmounted the filesystem?
> >>>>>
> >>>>> I think this ought to not need a umount first. From a UI standpoint,
> >>>>> just doing a "mount -o remount" ought to be sufficient to clear this.
> >>>>>
> >>>> This series is mainly for the case that mount point is not umountable.
> >>>> If mount point is umountable, user should use 'umount -f /ceph; mount
> >>>> /ceph'. This avoids all trouble of error handling.
> >>>>
> >>>
> >>> ...
> >>>
> >>>> If just doing "mount -o remount", user will expect there is no
> >>>> data/metadata get lost.  The 'mount -f' explicitly tell user this
> >>>> operation may lose data/metadata.
> >>>>
> >>>>
> >>>
> >>> I don't think they'd expect that and even if they did, that's why we'd
> >>> return errors on certain operations until they are cleared. But, I think
> >>> all of this points out the main issue I have with this patchset, which
> >>> is that it's not clear what problem this is solving.
> >>>
> >>> So: client gets blacklisted and we want to allow it to come back in some
> >>> fashion. Do we expect applications that happened to be accessing that
> >>> mount to be able to continue running, or will they need to be restarted?
> >>> If they need to be restarted why not just expect the admin to kill them
> >>> all off, unmount and remount and then start them back up again?
> >>>
> >>
> >> The point is let users decide what to do. Some user values
> >> availability over consistency. It's inconvenient to kill all
> >> applications that use the mount, then do umount.
> >>
> >>
> >
> > I think I have a couple of issues with this patchset. Maybe you can
> > convince me though:
> >
> > 1) The interface is really weird.
> >
> > You suggested that we needed to do:
> >
> >      # umount -f /mnt/foo ; mount -o remount /mnt/foo
> >
> > ...but what if I'm not really blacklisted? Didn't I just kill off all
> > the calls in-flight with the umount -f? What if that umount actually
> > succeeds? Then the subsequent remount call will fail.
> >
> > ISTM, that this interface (should we choose to accept it) should just
> > be:
> >
> >      # mount -o remount /mnt/foo
> >
>
> I have patch that does
>
> mount -o remount,force_reconnect /mnt/ceph

I think we can improve this with automatic recovery. It just requires
configuration of the behavior via mount options. What is your reason
for preferring an explicit remount operation?

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
