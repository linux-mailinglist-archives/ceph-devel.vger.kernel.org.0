Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4A7FC71E
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 14:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfKNNPb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 08:15:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfKNNPa (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 08:15:30 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C51920715;
        Thu, 14 Nov 2019 13:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573737329;
        bh=oO0LVq3AgLJ4ejYpIckz8rTV2rTNGUkQ4Jb0FD5zXGE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q1txG8Xg9f6m8GGV+Zb+sCvc5UcZ80yigAffnlOKjPqNZM1zBksB2YUoWVucOWFJ5
         rxJL4fv6SQ21/0PrIY+RN+XSzyxt7n3e7FhM5f/R1KvPJMpBtsckp95AN4ZY4zMc2c
         GwRd7WEJ9exaRu8BEtIib1CeP/AA9IzrkH/QRK/E=
Message-ID: <cbda3a69d25b04e10332e7b3898064a93b2d04ae.camel@kernel.org>
Subject: Re: [RFC PATCH v2 0/4] ceph: safely use 'copy-from' Op on Octopus
 OSDs
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 14 Nov 2019 08:15:28 -0500
In-Reply-To: <20191114105736.8636-1-lhenriques@suse.com>
References: <20191114105736.8636-1-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-11-14 at 10:57 +0000, Luis Henriques wrote:
> Hi!
> 
> So, after the feedback I got from v1 [1] I've sent out a pull-request
> for the OSDs [2] which encodes require_osd_release into the OSDMap
> client data.  This allows the client to figure out which ceph release
> the OSDs cluster is running and decide whether or not it's safe to use
> the copy-from Op for copy_file_range.
> 
> This new patchset I'm sending simply adds enough functionality to the
> kernel client so that it can take advantage of this OSD patch:
> 
> 0001 - adds the ability to decode TYPE_MSGR2 addresses.  This is a
>        required functionality for enabling SERVER_NAUTILUS in the
>        client.  I hope I got the new format right, as I couldn't figure
>        out what the hard-coded values (see comments) really mean.
> 

nit: the first 3 patch subject lines should probably be prefixed with
"libceph:"

> 0002 - allows the client to retrieve the new require_osd_release field
>        from the OSDMap if available.  This patch also adds SERVER_MIMIC,
>        SERVER_NAUTILUS and SERVER_OCTOPUS to the supported features,
>        which TBH I'm not sure if that's a safe thing to do -- the only
>        issue I've seen was that Nautilus requires the ability to decode
>        TYPE_MSGR2 address, but I may have missed others.
> 

Yes, this needs to be done with care. We have to ensure that the server
side isn't assuming that the client supports something that it doesn't.
I think that means just trawling through the code and verifying whether
this is safe.

> 0003 - debug code to add require_osd_release to the osdmap debugfs file.
> 
> 0004 - adds the truncate_{seq,size} fields to the 'copy-from' operation
>        if the OSDs are >= Octopus.
> 
> Also note that, as suggested by Ilya, I've dropped the patch that would
> change the default mount options to 'copyfrom'.
> 
> These patches have been tested with the xfstests generic test suite, and
> with a couple of other (local) tests that exercise the cephfs
> copy_file_range syscall.  I didn't saw any issues, but as I said above,
> I'm not really sure if adding the SERVER_* flags to the supported
> features have other side effects.
> 
> [1] https://lore.kernel.org/lkml/20191108141555.31176-1-lhenriques@suse.com/
> [2] https://github.com/ceph/ceph/pull/31611
> 

I'm just getting caught up on the discussion here, but why was it
decided to do it this way instead of just adding a new OSD
"copy-from-no-truncseq" operation? Once you tried it once and an OSD
didn't support it, you could just give up on using it any longer? That
seems a lot simpler than trying to monkey with feature bits.

-- 
Jeff Layton <jlayton@kernel.org>

