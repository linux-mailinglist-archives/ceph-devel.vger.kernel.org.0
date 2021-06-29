Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F123B7102
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 12:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbhF2K4Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 06:56:25 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:35922 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhF2K4Y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Jun 2021 06:56:24 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 75C98203CD;
        Tue, 29 Jun 2021 10:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624964036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K+G78bmJVjyhNZchwcJDgnrc6DlJX9RZKMOhgUqWpNw=;
        b=R/Ao6fB9u2OtiA0Tmqg/hn/Ypywah0/JBDeLcTFCgCGLdLoLHOgtTEu9e3x4LF7x1hLbIY
        T7v3g7Qb/OWYv+Y38rkjmgtA3dOfKJ8AsZjQFFzK0QjAxAiRqqXTjnuYRZG3YaozL8NPV4
        /5KYY22m+zHaiILsTe7JHD18A9vDhx4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624964036;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K+G78bmJVjyhNZchwcJDgnrc6DlJX9RZKMOhgUqWpNw=;
        b=F4hceaoXgEhnKs/7yNe9BAPeWg4l/kVg8Wgwe2AW/mSNqkvyH647d5OAoovDen9TfcDgOp
        JDvAlwasqexv/vDQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 14F6211906;
        Tue, 29 Jun 2021 10:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624964036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K+G78bmJVjyhNZchwcJDgnrc6DlJX9RZKMOhgUqWpNw=;
        b=R/Ao6fB9u2OtiA0Tmqg/hn/Ypywah0/JBDeLcTFCgCGLdLoLHOgtTEu9e3x4LF7x1hLbIY
        T7v3g7Qb/OWYv+Y38rkjmgtA3dOfKJ8AsZjQFFzK0QjAxAiRqqXTjnuYRZG3YaozL8NPV4
        /5KYY22m+zHaiILsTe7JHD18A9vDhx4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624964036;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K+G78bmJVjyhNZchwcJDgnrc6DlJX9RZKMOhgUqWpNw=;
        b=F4hceaoXgEhnKs/7yNe9BAPeWg4l/kVg8Wgwe2AW/mSNqkvyH647d5OAoovDen9TfcDgOp
        JDvAlwasqexv/vDQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id tJxXAcT72mASFAAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Tue, 29 Jun 2021 10:53:56 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id dc7036a9;
        Tue, 29 Jun 2021 10:53:55 +0000 (UTC)
Date:   Tue, 29 Jun 2021 11:53:55 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/2] ceph: allow schedule_delayed() callers to set
 delay for workqueue
Message-ID: <YNr7w3rFH23Ip80b@suse.de>
References: <20210629094749.25253-1-lhenriques@suse.de>
 <20210629094749.25253-2-lhenriques@suse.de>
 <CAOi1vP8_x7gEGaKvKMKdGSCzs2OSJNeXPZ_KVLqdg051wpZfYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP8_x7gEGaKvKMKdGSCzs2OSJNeXPZ_KVLqdg051wpZfYA@mail.gmail.com>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 29, 2021 at 12:14:37PM +0200, Ilya Dryomov wrote:
> On Tue, Jun 29, 2021 at 11:47 AM Luis Henriques <lhenriques@suse.de> wrote:
> >
> > Allow schedule_delayed() callers to explicitly set the delay value instead
> > of defaulting to a 5 secs value.
> >
> > Signed-off-by: Luis Henriques <lhenriques@suse.de>
> > ---
> >  fs/ceph/mds_client.c | 19 ++++++++++++-------
> >  1 file changed, 12 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index e5af591d3bd4..08c76bf57fb1 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -4502,13 +4502,18 @@ void inc_session_sequence(struct ceph_mds_session *s)
> >  }
> >
> >  /*
> > - * delayed work -- periodically trim expired leases, renew caps with mds
> > + * delayed work -- periodically trim expired leases, renew caps with mds.  If
> > + * the @delay parameter is set to 0 or if it's more than 5 secs, the default
> > + * workqueue delay value of 5 secs will be used.
> >   */
> > -static void schedule_delayed(struct ceph_mds_client *mdsc)
> > +static void schedule_delayed(struct ceph_mds_client *mdsc, unsigned long delay)
> >  {
> > -       int delay = 5;
> > -       unsigned hz = round_jiffies_relative(HZ * delay);
> > -       schedule_delayed_work(&mdsc->delayed_work, hz);
> > +       unsigned long max_delay = round_jiffies_relative(HZ * 5);
> > +
> > +       /* 5 secs default delay */
> > +       if (!delay || (delay > max_delay))
> > +               delay = max_delay;
> > +       schedule_delayed_work(&mdsc->delayed_work, delay);
> 
> Hi Luis,
> 
> Is there a reason to not round the non-default delay?  Does it need to
> be precise?

Ah, right.  No, there's not reason for not rounding it too.  So, I could
have something like this instead:

	unsigned long max_delay = HZ * 5;

	/* 5 secs default delay */
	if (!delay || (delay > max_delay))
		delay = max_delay;
	schedule_delayed_work(&mdsc->delayed_work, round_jiffies_relative(delay));

I'll make sure v3 will include this change.  Thanks Ilya.

Cheers,
--
Luís
