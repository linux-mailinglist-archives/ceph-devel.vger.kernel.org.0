Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1B29013A
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Aug 2019 14:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfHPMTL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 16 Aug 2019 08:19:11 -0400
Received: from mail-out2.in.tum.de ([131.159.0.36]:33198 "EHLO
        mail-out2.informatik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727178AbfHPMTK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 16 Aug 2019 08:19:10 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Aug 2019 08:19:08 EDT
Received: by mail.in.tum.de (Postfix, from userid 107)
        id 37B571C0382; Fri, 16 Aug 2019 14:12:58 +0200 (CEST)
Received: (Authenticated sender: jelten)
        by mail.in.tum.de (Postfix) with ESMTPSA id D06FC1C037E;
        Fri, 16 Aug 2019 14:12:55 +0200 (CEST)
        (Extended-Queue-bit tech_mfmzo@fff.in.tum.de)
Subject: Re: deprecating inline_data support for CephFS
To:     Jeff Layton <jlayton@redhat.com>, ceph-users <ceph-users@ceph.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "dev@ceph.io" <dev@ceph.io>
References: <e392e00ed22ba37c37208988cf5a095150f6c45b.camel@redhat.com>
From:   Jonas Jelten <jelten@in.tum.de>
Openpgp: preference=signencrypt
Autocrypt: addr=jelten@in.tum.de; keydata=
 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
 q+iijNWFzc2h5Zk27Q==
Message-ID: <f1829e2b-f78a-1202-b15a-2b23c9a6183d@in.tum.de>
Date:   Fri, 16 Aug 2019 14:12:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <e392e00ed22ba37c37208988cf5a095150f6c45b.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi!

I've missed your previous post, but we do have inline_data enabled on our cluster.
We've not yet benchmarked, but the filesystem has a wide variety of file sizes, and it sounded like a good idea to speed
up performance. We mount it with the kernel client only, and I've had the subjective impression that latency was better
once we enabled the feature. Now that you say the kernel client has no write support for it, my impression is probably
wrong.

I think inline_data is a nice and easy way to improve performance when the CephFS metadata are on SSDs but the bulk data
is on HDDs. So I'd vote against removal and would instead vouch for improvements of this feature :)

If storage on the MDS is a problem, files could be stored on a different (e.g. SSD) pool instead, and the file size
limit and pool selection could be configured via xattrs. And there was some idea to store small objects not in the OSD
block, but only in the OSD's DB (which is more complicated to use than separate SSD-pool and HDD-pool, but when block.db
is on an SSD the speed would be better). Maybe this could all be combined to have better small-file performance in CephFS!

-- Jonas


On 16/08/2019 13.15, Jeff Layton wrote:
> A couple of weeks ago, I sent a request to the mailing list asking
> whether anyone was using the inline_data support in cephfs:
> 
>     https://docs.ceph.com/docs/mimic/cephfs/experimental-features/#inline-data
> 
> I got exactly zero responses, so I'm going to formally propose that we
> move to start deprecating this feature for Octopus.
> 
> Why deprecate this feature?
> ===========================
> While the userland clients have support for both reading and writing,
> the kernel only has support for reading, and aggressively uninlines
> everything as soon as it needs to do any writing. That uninlining has
> some rather nasty potential race conditions too that could cause data
> corruption.
> 
> We could work to fix this, and maybe add write support for the kernel,
> but it adds a lot of complexity to the read and write codepaths in the
> clients, which are already pretty complex. Given that there isn't a lot
> of interest in this feature, I think we ought to just pull the plug on
> it.
> 
> How should we do this?
> ======================
> We should start by disabling this feature in master for Octopus. 
> 
> In particular, we should stop allowing users to call "fs set inline_data
> true" on filesystems where it's disabled, and maybe throw a loud warning
> about the feature being deprecated if the mds is started on a filesystem
> that has it enabled.
> 
> We could also consider creating a utility to crawl an existing
> filesystem and uninline anything there, if there was need for it.
> 
> Then, in a few release cycles, once we're past the point where someone
> can upgrade directly from Nautilus (release Q or R?) we'd rip out
> support for this feature entirely.
> 
> Thoughts, comments, questions welcome.
> 
