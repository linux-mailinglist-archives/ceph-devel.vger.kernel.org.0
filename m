Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19996200890
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Jun 2020 14:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732909AbgFSMWG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 Jun 2020 08:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731186AbgFSMWD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 19 Jun 2020 08:22:03 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03DD620809;
        Fri, 19 Jun 2020 12:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592569322;
        bh=wZ2eQjYZYfkCo5F3WxaCUB5bUgWSPPF1tVsfNqRvBhw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=zisCw7KKxl8lUtnRnMG308nWWNgW6Q0CW7J8N91o0qv0j/21OB/9wDOLtxoiyMJ61
         Im9X8sbgrqMIl/2BYEakDSXCbRmPrace4bVyIUX7KipaHTK+7AMWB+wwGX5Dz67lfi
         q0v/iJGh43heEXvV2Xu7Y3I/SCHYPZO7fFKxo9D0=
Message-ID: <5f985d1c59ad5e562bcf4c19514137d5041ddc80.camel@kernel.org>
Subject: Re: [PATCH v2 2/5] ceph: periodically send perf metrics to ceph
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Venky Shankar <vshankar@redhat.com>
Date:   Fri, 19 Jun 2020 08:22:01 -0400
In-Reply-To: <CAOi1vP81JshWEX7Ja1hqA4512ZBCVNiZX=204ijH15RrVeiT1Q@mail.gmail.com>
References: <1592481599-7851-1-git-send-email-xiubli@redhat.com>
         <1592481599-7851-3-git-send-email-xiubli@redhat.com>
         <0b035117f68e00be64569021e10e202371589205.camel@kernel.org>
         <f15a5885-3a9b-f308-bb5f-585f14e8ad19@redhat.com>
         <CAOi1vP81JshWEX7Ja1hqA4512ZBCVNiZX=204ijH15RrVeiT1Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-06-19 at 11:35 +0200, Ilya Dryomov wrote:
> On Fri, Jun 19, 2020 at 2:38 AM Xiubo Li <xiubli@redhat.com> wrote:
> > On 2020/6/18 22:42, Jeff Layton wrote:
> > > On Thu, 2020-06-18 at 07:59 -0400, xiubli@redhat.com wrote:
> > > > From: Xiubo Li <xiubli@redhat.com>
> > > > 
> > > > This will send the caps/read/write/metadata metrics to any available
> > > > MDS only once per second as default, which will be the same as the
> > > > userland client, or every metric_send_interval seconds, which is a
> > > > module parameter.
> > > > 
> > > > URL: https://tracker.ceph.com/issues/43215
> > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > ---
> > > >   fs/ceph/mds_client.c         |   3 +
> > > >   fs/ceph/metric.c             | 134 +++++++++++++++++++++++++++++++++++++++++++
> > > >   fs/ceph/metric.h             |  78 +++++++++++++++++++++++++
> > > >   fs/ceph/super.c              |  49 ++++++++++++++++
> > > >   fs/ceph/super.h              |   2 +
> > > >   include/linux/ceph/ceph_fs.h |   1 +
> > > >   6 files changed, 267 insertions(+)
> > > > 
> > > > 
> > > I think 3/5 needs to moved ahead of this one or folded into it, as we'll
> > > have a temporary regression otherwise.
> > > 
> > > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > > index c9784eb1..5f409dd 100644
> > > > --- a/fs/ceph/super.c
> > > > +++ b/fs/ceph/super.c
> > > > @@ -27,6 +27,9 @@
> > > >   #include <linux/ceph/auth.h>
> > > >   #include <linux/ceph/debugfs.h>
> > > > 
> > > > +static DEFINE_MUTEX(ceph_fsc_lock);
> > > > +static LIST_HEAD(ceph_fsc_list);
> > > > +
> > > >   /*
> > > >    * Ceph superblock operations
> > > >    *
> > > > @@ -691,6 +694,10 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
> > > >      if (!fsc->wb_pagevec_pool)
> > > >              goto fail_cap_wq;
> > > > 
> > > > +    mutex_lock(&ceph_fsc_lock);
> > > > +    list_add_tail(&fsc->list, &ceph_fsc_list);
> > > > +    mutex_unlock(&ceph_fsc_lock);
> > > > +
> > > >      return fsc;
> > > > 
> > > >   fail_cap_wq:
> > > > @@ -717,6 +724,10 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
> > > >   {
> > > >      dout("destroy_fs_client %p\n", fsc);
> > > > 
> > > > +    mutex_lock(&ceph_fsc_lock);
> > > > +    list_del(&fsc->list);
> > > > +    mutex_unlock(&ceph_fsc_lock);
> > > > +
> > > >      ceph_mdsc_destroy(fsc);
> > > >      destroy_workqueue(fsc->inode_wq);
> > > >      destroy_workqueue(fsc->cap_wq);
> > > > @@ -1282,6 +1293,44 @@ static void __exit exit_ceph(void)
> > > >      destroy_caches();
> > > >   }
> > > > 
> > > > +static int param_set_metric_interval(const char *val, const struct kernel_param *kp)
> > > > +{
> > > > +    struct ceph_fs_client *fsc;
> > > > +    unsigned int interval;
> > > > +    int ret;
> > > > +
> > > > +    ret = kstrtouint(val, 0, &interval);
> > > > +    if (ret < 0) {
> > > > +            pr_err("Failed to parse metric interval '%s'\n", val);
> > > > +            return ret;
> > > > +    }
> > > > +
> > > > +    if (interval > 5) {
> > > > +            pr_err("Invalid metric interval %u\n", interval);
> > > > +            return -EINVAL;
> > > > +    }
> > > > +
> > > Why do we want to reject an interval larger than 5s? Is that problematic
> > > for some reason?
> > 
> > IMO, a larger interval doesn't make much sense, to limit the interval
> > value in 5s to make sure that the ceph side could show the client real
> > metrics in time. Is this okay ? Or should we use a larger limit ?
> 

5s may seem like a lot now, but in 5-10 years we might be wishing we had
the ability to change this to something else (e.g.: maybe we find that
stats every 5s cause undue load on the MDS, and need to increase it).

> I wonder if providing the option to tune the interval makes sense
> at all then.  Since most clients will be sending their metrics every
> second, the MDS may eventually start relying on that in some way.
> Would a simple on/off switch, to be used if sending metrics causes
> unforeseen trouble, work?
> 

Yeah, I'm leery of grabbing values out of our nether regions like this,
and it doesn't seem like making this that configurable has many
benefits.

Perhaps the preferred interval should be something advertised by the MDS
in some way? New field in the mdsmap, perhaps?
-- 
Jeff Layton <jlayton@kernel.org>

