Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA73443F9B
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jun 2019 17:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfFMP6p (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jun 2019 11:58:45 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:48642 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfFMP6o (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Jun 2019 11:58:44 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id C6D9C15F8E2;
        Thu, 13 Jun 2019 08:58:42 -0700 (PDT)
Date:   Thu, 13 Jun 2019 15:58:40 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Alexandre DERUMIER <aderumier@odiso.com>
cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Xiaoxi Chen <superdebuger@gmail.com>, ifedotov@suse.de
Subject: Re: [ceph-users] ceph osd commit latency increase over time, until
 restart
In-Reply-To: <1245896958.760752.1560441303007.JavaMail.zimbra@odiso.com>
Message-ID: <alpine.DEB.2.11.1906131557220.12100@piezo.novalocal>
References: <fa985d7d-8a62-c15c-9a09-71ff5c2b7cb8@suse.de> <9810a6e6-87f9-d7b6-6ce3-a4ba234d4498@suse.de> <CAEYCsVJjT2UMUn+jGHD_eHB8SnONTrXBjvH_EHSwd+wngMfOdA@mail.gmail.com> <CAEYCsVLQpfSGRDy9-RSR-OwXH5mNuss5mpVGu9_6Dtno4TxKSw@mail.gmail.com>
 <alpine.DEB.2.11.1903041517210.6707@piezo.novalocal> <1052895146.988276.1551776452235.JavaMail.zimbra@odiso.com> <alpine.DEB.2.11.1903051625400.6707@piezo.novalocal> <CAEYCsVLf26VTUKnLEXx-zXzNwFd6ZA1TpRg_-EDAuVuiJ5Sqjg@mail.gmail.com>
 <1245896958.760752.1560441303007.JavaMail.zimbra@odiso.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1404950208-1560441486=:12100"
Content-ID: <alpine.DEB.2.11.1906131558130.12100@piezo.novalocal>
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudehledgleehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffujgfkfhgfgggtsehmtderredtreejnecuhfhrohhmpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepuddvjedrtddrtddrudenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdpihhnvghtpeduvdejrddtrddtrddupdhrvghtuhhrnhdqphgrthhhpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqpdhmrghilhhfrhhomhepshgrghgvsehnvgifughrvggrmhdrnhgvthdpnhhrtghpthhtohepihhfvgguohhtohhvsehsuhhsvgdruggvnecuvehluhhsthgvrhfuihiivgeptd
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1404950208-1560441486=:12100
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.11.1906131558131.12100@piezo.novalocal>

On Thu, 13 Jun 2019, Alexandre DERUMIER wrote:
> Hi,
> 
> I have upgraded to last mimic with bitmap allocator,
> 
> since one week, latency are very stable (0,7-1ms), tested on 5 differents clusters.
> 
> (Previously I had latency increase after 2days)
> 
> So it's really seem to be fixed :)
> 
> I'll try to confirm this in this thread next month.
> 
> 
> Thanks again to all ceph devs !

Yay!  A big thank you to Igor, who did all of the heavy lifting here! :)

sage


> 
> 
> 
> ----- Mail original -----
> De: "Xiaoxi Chen" <superdebuger@gmail.com>
> À: "Sage Weil" <sage@newdream.net>
> Cc: "aderumier" <aderumier@odiso.com>, "ceph-devel" <ceph-devel@vger.kernel.org>
> Envoyé: Jeudi 7 Mars 2019 15:15:52
> Objet: Re: [ceph-users] ceph osd commit latency increase over time, until restart
> 
> Hi Igor and Sage, 
> Some more updates, the periodically reset for stupid allocator( [ https://github.com/ceph/ceph/commits/wip-ifed-reset-allocator-luminous | https://github.com/ceph/ceph/commits/wip-ifed-reset-allocator-luminous ] ) works well too, though itt will make a 80ms spike in latency during the reset, under my workload. 
> 
> Grad to know (new) bitmap allocator will be backport, do we have a target version and release date? With this luminous version we dont need to rush to Nautilus in production. 
> 
> 
> Xiaoxi 
> 
> Sage Weil < [ mailto:sage@newdream.net | sage@newdream.net ] > 于2019年3月6日周三 上午12:27写道： 
> 
> 
> On Tue, 5 Mar 2019, Alexandre DERUMIER wrote: 
> > >> Now that we've pinpointed the 
> > >>problem, it is likely we'll backport the new implementation to luminous. 
> > 
> > Hi Sage, is it also planned for mimic ? 
> 
> Yes. Everything we backport will include later releases so that there 
> aren't regressions on upgrade. (Although we haven't been strict about 
> making sure it is actually *released* in order too, so e.g., occasionally 
> an upgrade from latest luminous to latest mimic will miss something until 
> the next mimic release.) 
> 
> sage 
> 
> 
> 
> > 
> > ----- Mail original ----- 
> > De: "Sage Weil" < [ mailto:sage@newdream.net | sage@newdream.net ] > 
> > À: "Xiaoxi Chen" < [ mailto:superdebuger@gmail.com | superdebuger@gmail.com ] > 
> > Cc: "ceph-devel" < [ mailto:ceph-devel@vger.kernel.org | ceph-devel@vger.kernel.org ] > 
> > Envoyé: Lundi 4 Mars 2019 16:18:47 
> > Objet: Re: Fwd: [ceph-users] ceph osd commit latency increase over time, until restart 
> > 
> > On Mon, 4 Mar 2019, Xiaoxi Chen wrote: 
> > > [Resend with pure text] 
> > > 
> > > Hi List, 
> > > 
> > > After 3 days + bake, the bitmap allocator shows much better 
> > > performance characteristics compared to stupid. The osd.44 is nautilus 
> > > + bitmap allocator, osd.19 is luminous + bitmap, as a comparison, 
> > > osd.406 just did a fresh restart but continue with luminous + stupid. 
> > > See [ https://pasteboard.co/I3SkfuN.png | https://pasteboard.co/I3SkfuN.png ] for figure. 
> > 
> > I just want to follow this up with a warning: 
> > 
> > ** DO NOT USE BITMAP ALLOCATOR ON LUMINOUS IN PRODUCTION ** 
> > 
> > We made luminous default to StupidAllocator because we saw instability 
> > with the (old) bitmap implementation. In Natuilus, there is a completely 
> > new implementation (with similar design). Now that we've pinpointed the 
> > problem, it is likely we'll backport the new implementation to luminous. 
> > 
> > Thanks! 
> > sage 
> > 
> > 
> > > 
> > > Nautilus shows best performance consistency, max at 20ms compared 
> > > to 92 ms in luminous.( [ https://pasteboard.co/I3SkxxK.png | https://pasteboard.co/I3SkxxK.png ] ) 
> > > 
> > > In the same time, as Igor point out, the stupid can be fragment 
> > > and there is no de-frag functionality in there, so it is slower over 
> > > time. This theory can be prove by the mempool status of OSDs before 
> > > and after reboot. You can see the tree shrink 9 times. 
> > > 
> > > Before reboot: 
> > > 
> > > "bluestore_alloc": { 
> > > 
> > > "items": 915127024, 
> > > 
> > > "bytes": 915127024 
> > > 
> > > }, 
> > > 
> > > 
> > > After reboot, 
> > > 
> > > "bluestore_alloc": { 
> > > 
> > > "items": 104727568, 
> > > 
> > > "bytes": 104727568 
> > > 
> > > }, 
> > > 
> > > 
> > > 
> > > I am extending the Nautilus deployment to 1 rack, and in 
> > > another rack I changed the min_alloc_size from 4K to 32k, to see if it 
> > > can relieve the b-tree a bit. 
> > > Also trying Igor's testing branch at 
> > > [ https://github.com/ceph/ceph/commits/wip-ifed-reset-allocator-luminous | https://github.com/ceph/ceph/commits/wip-ifed-reset-allocator-luminous ] . 
> > > 
> > > Xiaoxi 
> > > 
> > > Igor Fedotov < [ mailto:ifedotov@suse.de | ifedotov@suse.de ] > 于2019年3月3日周日 上午3:24写道： 
> > > > 
> > > > Hi Xiaoxi, 
> > > > 
> > > > Please note that this PR is proof-of-concept hence I didn't try to 
> > > > implement the best algorithm. 
> > > > 
> > > > But IMO your approach is not viable (or at least isn't that simple) 
> > > > though since freelist manager (and RocksDB) doesn't contain up to date 
> > > > allocator state at arbitrary moment of time - running transactions might 
> > > > have some pending allocations that were processed by allocator but 
> > > > haven't landed to DB yet. So one is unable to restore valid allocator 
> > > > state from Freelist Manager unless he finalizes all the transactions. 
> > > > Which looks a bit troublesome... 
> > > > 
> > > > 
> > > > Thanks, 
> > > > 
> > > > Igor 
> > > > 
> > > > 
> > > > On 3/2/2019 6:41 PM, Xiaoxi Chen wrote: 
> > > > > Hi Igor, 
> > > > > Thanks, no worry I will build it locally and test , will update 
> > > > > this thread if I get anything. 
> > > > > 
> > > > > 
> > > > > The commit 
> > > > > [ https://github.com/ceph/ceph/commit/8ee87c22bcd88a8911d58936cec9049e0932fb77 | https://github.com/ceph/ceph/commit/8ee87c22bcd88a8911d58936cec9049e0932fb77 ] make 
> > > > > sense though the concern is the full defragment will take long time. 
> > > > > 
> > > > > Do you see it will be faster to use freelist manager rather than 
> > > > > iterate every btree , insert to common one and re-build original 
> > > > > b-tree? The freelist manager should always de-fraged in anytime. 
> > > > > 
> > > > > fm->enumerate_reset(); 
> > > > > uint64_t offset, length; 
> > > > > while (fm->enumerate_next(&offset, &length)) { 
> > > > > alloc->init_add_free(offset, length); 
> > > > > ++num; 
> > > > > bytes += length; 
> > > > > } 
> > > > > 
> > > > > Xiaoxi 
> > > > > 
> > > > > Igor Fedotov < [ mailto:ifedotov@suse.de | ifedotov@suse.de ] <mailto: [ mailto:ifedotov@suse.de | ifedotov@suse.de ] >> 
> > > > > 于2019年3月2日周六 上午3:23写道： 
> > > > > 
> > > > > Xiaoxi, 
> > > > > 
> > > > > Here is the luminous patch which performs StupidAllocator reset 
> > > > > once per 12 hours. 
> > > > > 
> > > > > [ https://github.com/ceph/ceph/tree/wip-ifed-reset-allocator-luminous | https://github.com/ceph/ceph/tree/wip-ifed-reset-allocator-luminous ] 
> > > > > 
> > > > > Sorry, didn't have enough time today to learn how to make a 
> > > > > package from it, just sources for now. 
> > > > > 
> > > > > 
> > > > > Thanks, 
> > > > > 
> > > > > Igor 
> > > > > 
> > > > > 
> > > > > On 3/1/2019 11:46 AM, Xiaoxi Chen wrote: 
> > > > >> igor， 
> > > > >> I can test the patch if we have a package. 
> > > > >> My enviroment and workload can consistently reproduce the 
> > > > >> latency 2-3 days after restarting. 
> > > > >> Sage tells me to try bitmap allocator to make sure stupid 
> > > > >> allocator is the bad guy. I have some osds in luminous +bitmap 
> > > > >> and some osds in 14.1.0+bitmap. Both looks positive till now, 
> > > > >> but i need more time to be sure. 
> > > > >> The perf ,log and admin socket analysis lead to the theory 
> > > > >> that in alloc_int the loop sometimes take long time wkth 
> > > > >> allocator locks held. Which blocks release part called from 
> > > > >> _txc_finish in kv_finalize_thread, this thread is also the one to 
> > > > >> calculate state_kv_committing_lat and overall commit_lat. You can 
> > > > >> find from admin socket that state_done_latency has similar trend 
> > > > >> as commit_latency. 
> > > > >> But we cannot find a theory to.explain why reboot helps, the 
> > > > >> allocator btree will be rebuild from freelist manager 
> > > > >> and.it.should be exactly. the same as it is prior to reboot. 
> > > > >> Anything related with pg recovery? 
> > > > >> 
> > > > >> Anyway, as I have a live env and workload, I am more than 
> > > > >> willing to work with you for further investigatiom 
> > > > >> 
> > > > >> -Xiaoxi 
> > > > >> 
> > > > >> Igor Fedotov < [ mailto:ifedotov@suse.de | ifedotov@suse.de ] <mailto: [ mailto:ifedotov@suse.de | ifedotov@suse.de ] >> 于 
> > > > >> 2019年3月1日周五 上午6:21写道： 
> > > > >> 
> > > > >> Also I think it makes sense to create a ticket at this point. 
> > > > >> Any 
> > > > >> volunteers? 
> > > > >> 
> > > > >> On 3/1/2019 1:00 AM, Igor Fedotov wrote: 
> > > > >> > Wondering if somebody would be able to apply simple patch that 
> > > > >> > periodically resets StupidAllocator? 
> > > > >> > 
> > > > >> > Just to verify/disprove the hypothesis it's allocator relateted 
> > > > >> > 
> > > > >> > On 2/28/2019 11:57 PM, Stefan Kooman wrote: 
> > > > >> >> Quoting Wido den Hollander ( [ mailto:wido@42on.com | wido@42on.com ] 
> > > > >> <mailto: [ mailto:wido@42on.com | wido@42on.com ] >): 
> > > > >> >>> Just wanted to chime in, I've seen this with 
> > > > >> Luminous+BlueStore+NVMe 
> > > > >> >>> OSDs as well. Over time their latency increased until we 
> > > > >> started to 
> > > > >> >>> notice I/O-wait inside VMs. 
> > > > >> >> On a Luminous 12.2.8 cluster with only SSDs we also hit 
> > > > >> this issue I 
> > > > >> >> guess. After restarting the OSD servers the latency would 
> > > > >> drop to normal 
> > > > >> >> values again. See 
> > > > >> [ https://owncloud.kooman.org/s/BpkUc7YM79vhcDj | https://owncloud.kooman.org/s/BpkUc7YM79vhcDj ] 
> > > > >> >> 
> > > > >> >> Reboots were finished at ~ 19:00. 
> > > > >> >> 
> > > > >> >> Gr. Stefan 
> > > > >> >> 
> > > > >> 
> > > 
> > > 
> > > 
> > 
> > 
> > 
> 
> 
> 
> 
> 
--8323329-1404950208-1560441486=:12100--
