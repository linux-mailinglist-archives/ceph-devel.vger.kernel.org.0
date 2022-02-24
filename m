Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683604C29B4
	for <lists+ceph-devel@lfdr.de>; Thu, 24 Feb 2022 11:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbiBXKjA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 24 Feb 2022 05:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbiBXKi6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 24 Feb 2022 05:38:58 -0500
Received: from 2.mo302.mail-out.ovh.net (2.mo302.mail-out.ovh.net [137.74.110.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C4A247750
        for <ceph-devel@vger.kernel.org>; Thu, 24 Feb 2022 02:38:27 -0800 (PST)
Received: from DAGFR5EX1.OVH.local (unknown [51.255.55.251])
        by mo302.mail-out.ovh.net (Postfix) with ESMTPS id 81CD666A59;
        Thu, 24 Feb 2022 11:38:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ovhcloud.com;
        s=mailout; t=1645699105;
        bh=y/f6vD3mtxpyAON9IYj1KbSZnnl3x+5+s/SMbCFbC0s=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=TlY6XqdtnrLL11oxYY9PoxOKjCwAGEWhCBG0Q5PjF03xQT7tTKR5mFhvf0sZb1z02
         FjLjaD3v/245/9obR5eYwsNhyUynXVTpXO98eFK8Aj4CDQh2W6H7OgPu4Wrj8xgrKc
         OZQXbi+vtVwClpd4NEB9Wo31Ju1LuhwyoC7ETUY8=
Received: from [10.15.52.118] (109.190.254.30) by DAGFR5EX1.OVH.local
 (172.16.2.14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.15; Thu, 24 Feb
 2022 11:38:24 +0100
Message-ID: <c9e1294b-b905-0a34-4b32-3d7b5d46c03a@ovhcloud.com>
Date:   Thu, 24 Feb 2022 11:38:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Benching ceph for high speed RBD
Content-Language: en-US
To:     Mark Nelson <mnelson@redhat.com>, dev <dev@ceph.io>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <d55c21fb8ba54ee1b8b1e60ccc0bb21b@ovhcloud.com>
 <47a841af-6bcd-8e8d-d6dd-2071f435bd6f@redhat.com>
 <2062509e562b439098aef109146d2cf9@ovhcloud.com>
 <d6092114-9f99-157d-1808-10bd7f0bc446@redhat.com>
From:   "bartosz.rabiega@ovhcloud.com" <bartosz.rabiega@ovhcloud.com>
In-Reply-To: <d6092114-9f99-157d-1808-10bd7f0bc446@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [109.190.254.30]
X-ClientProxiedBy: DAGFR9EX2.OVH.local (172.16.2.27) To DAGFR5EX1.OVH.local
 (172.16.2.14)
X-OVH-CORPLIMIT-SKIP: true
X-Ovh-Tracer-Id: 6926817704563367497
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrledvgddujecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfhfhfgjtgfgihesthekredttdefjeenucfhrhhomhepfdgsrghrthhoshiirdhrrggsihgvghgrsehovhhhtghlohhuugdrtghomhdfuceosggrrhhtohhsiidrrhgrsghivghgrgesohhvhhgtlhhouhgurdgtohhmqeenucggtffrrghtthgvrhhnpeehveegjeefveeuhfduvdejfeehffethefftdejveffudffgeeutdfgvddtveduteenucffohhmrghinheptggvphhhrdgtohhmpdhusghunhhtuhdrtghomhenucfkpheptddrtddrtddrtddpuddtledrudeltddrvdehgedrfedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopefftefihffthefgigdurdfqggfjrdhlohgtrghlpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegsrghrthhoshiirdhrrggsihgvghgrsehovhhhtghlohhuugdrtghomhdpnhgspghrtghpthhtohepuddprhgtphhtthhopegtvghphhdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hey,

To be precise about ceph versions

15.2.14 from http://eu.ceph.com/debian-15.2.14/
15.2.15 from http://eu.ceph.com/debian-15.2.15/
- both of these versions reach
~75k 4k qd4 writes
~650k 4k qd64 reads
re-tested on 15.2.14 vanilla yesterday on a fresh cluster, 1h fio per 
each test)

15.2.14 (15.2.14-0ubuntu0.20.04.2) from 
http://archive.ubuntu.com/ubuntu/dists/focal-updates/universe
- this one for some reason is special (build options?)
~110k 4k qd4 writes
~750k 4k qd64 reads
also tested on a fresh cluster with 1h fio runs

The PCIe scheduler thing looks very interesting. Although I think the 
issue is limited in my setup as each container is pinned to the NUMA 
node where corresponding NVMe is connected. So only the network card 
might be in a different NUMA.

BR


On 2/23/22 22:33, Mark Nelson wrote:
> Hi Bartosz,
> 
> 
> Yep, my IOPS results are calculated the same way.  Basically just a sum 
> of the averages as reported by fio with numjobs=1.  My numbers are 
> obviously higher, but I'm giving the OSDs a heck of a lot more CPU and 
> aggregate PCIe/Mem bus than you are so it's not unexpected.  It's 
> interesting that 15.2.14 is showing the best results in your testing but 
> none of the 15.2.X tests in my setup showed any real advantage.  Perhaps 
> it has something to do with the way you aged/upgraded the cluster.
> 
> 
> One issue that may be relevant for you:  At the 2021 Supercomputing Ceph 
> BOF, Andras Pataki from the Flatiron Institute presented findings on 
> their dual socket AMD Rome nodes where they were seeing significant 
> performance impact when running lots of NVMe drives.  They believe the 
> result was due to PCIe scheduler contention/latency with wide variations 
> in performance depending on which CPU OSDs landed on relative to the 
> NVMe drives and network.  AMD Rome systems typically have a special bios 
> setting called "Preferred I/O" that improves scheduling for a single 
> given PCIe device (which works), but at the expense of other PCIe 
> devices so it doesn't really help.  I don't know if there is a recording 
> of the talk, but it was extremely good. I suspect that may be impacting 
> your tests, especially if the container setup is resulting in lots of 
> OSDs landing on the wrong CPU relative to the NVMe drive.
> 
