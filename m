Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2642828D4BD
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Oct 2020 21:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgJMTlz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Oct 2020 15:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728729AbgJMTly (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Oct 2020 15:41:54 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD63CC0613DB
        for <ceph-devel@vger.kernel.org>; Tue, 13 Oct 2020 12:41:53 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id t25so1392747ejd.13
        for <ceph-devel@vger.kernel.org>; Tue, 13 Oct 2020 12:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jlOzF1QhqikCoQxsvfJV6M6Hjgbrow9dB9uNs1AoGLE=;
        b=kTjS5KS3nYcf/wrvTsuRt1BvzGw557kJOoPvyzYoBgiqb4b8bKtbI2/mMLiZYyRjFR
         J9ydTuu0x47x+MEvbUBFhFH3/2QgRWgMVRtg9k6OLuYDe131Mp/cuPa30fJMGhSFjepr
         cqBBXWNROTwzHkSN49lY/psarWhxU27El5EYWXEJaiWvhTqo66L6QK98x3Y0Yvi2nF9y
         UTW/CUag9LBP+VfPW+1mn8JfLpPCSXoAzeg5FBjWoJMu0+7UEW9Ka5T8iigFwOd+JDvR
         rrctnvxFOZW164mxjZq4IMmZGZxG4l2jAUbsCf6skOMzcKIRAwJ8OakZ/jL0rfexuXSd
         7ngQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jlOzF1QhqikCoQxsvfJV6M6Hjgbrow9dB9uNs1AoGLE=;
        b=dmHsbEbjG7j0WhyHehpWDd8bm5pSNZW19w+u7FQnyfYJapHxd6l5eZ9c1SRTkkglJE
         6llp+aaeIGwEvK3/KfbQeBQhVZ0+qC9R/VkVg6CCDXY/eFyG+lGIsxkkkrL08OibSW1R
         n3v8u8PINI1wgQfDOD41dKTbZmuHwVzuOqwPOZiIkMr7/3/jnRfXG2p/3rwjwaN95Qdn
         hIeWu08KLQi1DduoZsXYOCb0FlDlZlyyvdUbj2NtomQOgMAp4Af28ZD076eAPfJqoqdX
         qM+FJB1qTkzY+vt2qolJFLkst68xOwyvMqaxOLg8VnPR0kzytnPtWtroyWwWdLTMuErl
         +3kQ==
X-Gm-Message-State: AOAM530yy10v5lxS4wfV+0f/h7KqsOdQyQZfTj8iJD/SSBC4+K2aaRXA
        I9JSt2XrFqPlCkBhOBYULqV0/aEx9IGmIVqQyQJArg==
X-Google-Smtp-Source: ABdhPJxGxhMZ7o2BYtIDXOupUr3pSHVXck0tIwC9HMZ0nIbp0pU6AQKRljKqMwVkoxmX0BYp74elTVEnpYvo3LWFH24=
X-Received: by 2002:a17:906:7e47:: with SMTP id z7mr1390518ejr.418.1602618108255;
 Tue, 13 Oct 2020 12:41:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201009195033.3208459-1-ira.weiny@intel.com> <20201009195033.3208459-34-ira.weiny@intel.com>
 <CAPcyv4gL3jfw4d+SJGPqAD3Dp4F_K=X3domuN4ndAA1FQDGcPg@mail.gmail.com> <20201013193643.GK20115@casper.infradead.org>
In-Reply-To: <20201013193643.GK20115@casper.infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 13 Oct 2020 12:41:36 -0700
Message-ID: <CAPcyv4gL70FcLe8az7ezmpcZV=bG0Cka7daKWcCdmV4GoenSZw@mail.gmail.com>
Subject: Re: [PATCH RFC PKS/PMEM 33/58] fs/cramfs: Utilize new kmap_thread()
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Weiny, Ira" <ira.weiny@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Nicolas Pitre <nico@fluxnic.net>, X86 ML <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-kselftest@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        KVM list <kvm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Kexec Mailing List <kexec@lists.infradead.org>,
        linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org,
        devel@driverdev.osuosl.org, linux-efi <linux-efi@vger.kernel.org>,
        linux-mmc@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>,
        target-devel@vger.kernel.org, linux-nfs@vger.kernel.org,
        ceph-devel@vger.kernel.org,
        linux-ext4 <linux-ext4@vger.kernel.org>, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-um@lists.infradead.org, linux-ntfs-dev@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, cluster-devel@redhat.com,
        ecryptfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-afs@lists.infradead.org,
        linux-rdma <linux-rdma@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>, intel-gfx@lists.freedesktop.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        xen-devel <xen-devel@lists.xenproject.org>,
        linux-cachefs@redhat.com, samba-technical@lists.samba.org,
        intel-wired-lan@lists.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Oct 13, 2020 at 12:37 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Tue, Oct 13, 2020 at 11:44:29AM -0700, Dan Williams wrote:
> > On Fri, Oct 9, 2020 at 12:52 PM <ira.weiny@intel.com> wrote:
> > >
> > > From: Ira Weiny <ira.weiny@intel.com>
> > >
> > > The kmap() calls in this FS are localized to a single thread.  To avoid
> > > the over head of global PKRS updates use the new kmap_thread() call.
> > >
> > > Cc: Nicolas Pitre <nico@fluxnic.net>
> > > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > > ---
> > >  fs/cramfs/inode.c | 10 +++++-----
> > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
> > > index 912308600d39..003c014a42ed 100644
> > > --- a/fs/cramfs/inode.c
> > > +++ b/fs/cramfs/inode.c
> > > @@ -247,8 +247,8 @@ static void *cramfs_blkdev_read(struct super_block *sb, unsigned int offset,
> > >                 struct page *page = pages[i];
> > >
> > >                 if (page) {
> > > -                       memcpy(data, kmap(page), PAGE_SIZE);
> > > -                       kunmap(page);
> > > +                       memcpy(data, kmap_thread(page), PAGE_SIZE);
> > > +                       kunmap_thread(page);
> >
> > Why does this need a sleepable kmap? This looks like a textbook
> > kmap_atomic() use case.
>
> There's a lot of code of this form.  Could we perhaps have:
>
> static inline void copy_to_highpage(struct page *to, void *vfrom, unsigned int size)
> {
>         char *vto = kmap_atomic(to);
>
>         memcpy(vto, vfrom, size);
>         kunmap_atomic(vto);
> }
>
> in linux/highmem.h ?

Nice, yes, that could also replace the local ones in lib/iov_iter.c
(memcpy_{to,from}_page())
