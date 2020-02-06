Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8111547E1
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Feb 2020 16:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgBFPV6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Feb 2020 10:21:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727325AbgBFPV6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 6 Feb 2020 10:21:58 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC818214AF;
        Thu,  6 Feb 2020 15:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581002517;
        bh=mZ6WK3hoSCBVjVQsZQ40iPik0umxMuWLAj93AnBH0B8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IxCOfMPhvCZFiATXZub/wVcztwqjjrkZ1c7/B3zSCqzBFfqpw8vadj1p4JXJEDSgz
         DteKgJryIHsrKUcJ9OHbNsO0DI4zUpCOD4yHJzH7XaZpcnKVL6hRurv12ngdIWwnKm
         OZAdTMWj7xsitqXoICVVcrhJT0Ioe9HAL8qMjDgQ=
Message-ID: <e78f9a17667240c8f0da02e3913444dec9e0911c.camel@kernel.org>
Subject: Re: [PATCH resend v5 08/11] ceph: periodically send perf metrics to
 MDS
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 06 Feb 2020 10:21:55 -0500
In-Reply-To: <6010186e-6b3d-8664-b4e9-b6a015b6cca2@redhat.com>
References: <20200129082715.5285-1-xiubli@redhat.com>
         <20200129082715.5285-9-xiubli@redhat.com>
         <57de3eb2f2009aec0ba086bb9d95a2936a7d1d9f.camel@kernel.org>
         <d4b8f9a5-b2f7-ec71-c8fe-528ec24d8695@redhat.com>
         <1cf98f0bd2bda7eef3f6b8f5bfd42188ee74ef38.camel@kernel.org>
         <6010186e-6b3d-8664-b4e9-b6a015b6cca2@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-02-06 at 20:26 +0800, Xiubo Li wrote:
> On 2020/2/6 19:31, Jeff Layton wrote:
> > On Thu, 2020-02-06 at 10:36 +0800, Xiubo Li wrote:
> > > On 2020/2/6 5:43, Jeff Layton wrote:
> > > > On Wed, 2020-01-29 at 03:27 -0500, xiubli@redhat.com wrote:
> > > [...]
> > > > > +
> > > > > +static int sending_metrics_get(void *data, u64 *val)
> > > > > +{
> > > > > +	struct ceph_fs_client *fsc = (struct ceph_fs_client *)data;
> > > > > +	struct ceph_mds_client *mdsc = fsc->mdsc;
> > > > > +
> > > > > +	mutex_lock(&mdsc->mutex);
> > > > > +	*val = (u64)mdsc->sending_metrics;
> > > > > +	mutex_unlock(&mdsc->mutex);
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > > +DEFINE_SIMPLE_ATTRIBUTE(sending_metrics_fops, sending_metrics_get,
> > > > > +			sending_metrics_set, "%llu\n");
> > > > > +
> > > > I'd like to hear more about how we expect users to use this facility.
> > > > This debugfs file doesn't seem consistent with the rest of the UI, and I
> > > > imagine if the box reboots you'd have to (manually) re-enable it after
> > > > mount, right? Maybe this should be a mount option instead?
> > > A mount option means we must do the unmounting to disable it.
> > > 
> > Technically, no. You could wire it up so that you could enable and
> > disable it via -o remount. For example:
> > 
> >      # mount -o remount,metrics=disabled
> 
> Yeah, this is cool.
> 
> > Another option might be a module parameter if this is something that you
> > really want to be global (and not per-mount or per-session).
> > 
> > > I was thinking with the debugfs file we can do the debug or tuning even
> > > in the product setups at any time, usually this should be disabled since
> > > it will send it per second.
> > > 
> > Meh, one frame per second doesn't seem like it'll add much overhead.
> Okay.
> > Also, why one update per second? Should that interval be tunable?
> 
> Per second just keep it the same with the fuse client.
> 

Ok.

> 
> > > Or we could merge the "sending_metric" to "metrics" UI, just writing
> > > "enable"/"disable" to enable/disable sending the metrics to ceph, and
> > > just like the "reset" does to clean the metrics.
> > > 
> > > Then the "/sys/kernel/debug/ceph/XXX.clientYYY/metrics" could be
> > > writable with:
> > > 
> > > "reset"  --> to clean and reset the metrics counters
> > > 
> > > "enable" --> enable sending metrics to ceph cluster
> > > 
> > > "disable" --> disable sending metrics to ceph cluster
> > > 
> > > Will this be better ?
> > > 
> > I guess it's not clear to me how you intend for this to be used.
> > 
> > A debugfs switch means that this is being enabled and disabled on a per-
> > session basis. Is the user supposed to turn this on for all, or just one
> > session? How do they know?
> 
> Not for all, just per-superblock.
> 

If it's per-superblock, then a debugfs-based switch seems particularly
ill-suited for this, as that's really a per-session interface.

> > Is this something we expect people to just turn on briefly when they are
> > experiencing a problem, or is this something that we expect to be turned
> > on and left on for long periods of time?
> 
> If this won't add much overhead even per second, let's keep sending the 
> metrics to ceph always and the mount option for this switch is not 
> needed any more.
> 

Note that I don't really _know_ that it won't be a problem, just that it
doesn't sound too bad. I think we probably will want some mechanism to
enable/disable this until we have some experience with it in the field.

> And there is already a switch to enable/disable showing the metrics in 
> the ceph side, if here add another switch per client, it will be also 
> yucky for admins .
> 
> Let's make the update interval tunable and per second as default. Maybe 
> we should make this as a global UI for all clients ?
> 

If you want a global setting for the interval that would take effect on
all ceph mounts, then maybe a "metric_send_interval" module parameter
would be best. Make it an unsigned int, and allow the admin to set it to
0 to turn off stats transmission in the client.

We have a well-defined interface for setting module parameters on most
distros (via /etc/modprobe.d/), so that would be better than monkeying
around with debugfs here, IMO.

As to the default, it might be best to have this default to 0 initially.
Once we have more experience with it we could make it default to 1 in a
later release.

-- 
Jeff Layton <jlayton@kernel.org>

