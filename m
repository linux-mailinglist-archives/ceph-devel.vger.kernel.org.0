Return-Path: <ceph-devel+bounces-4450-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 198C2D2BC57
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Jan 2026 06:07:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B561D3019187
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Jan 2026 05:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FB7D344052;
	Fri, 16 Jan 2026 05:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SeQe9fjt"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6289732FA2A
	for <ceph-devel@vger.kernel.org>; Fri, 16 Jan 2026 05:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768539862; cv=none; b=oRv8Fsb+bL2f7jFwbGW745LRo3cQg4wqhbtOzNebiqJFSp34w6WnGHMubbhfLk4ZDEVLilHU2T5R8zZZFSuOkA9q8ChgJmEGzE6qaJoI7fipQOTJVl+LAd2NfTuNKHhyI2j0YPDf2Xj+MOuXvroZm9+gSIU43iwc03YuLsey0v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768539862; c=relaxed/simple;
	bh=y+VF+VnvBJg5g7q9V3nT7vcXNVvZuUBd+lyc424lKOY=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=GNBuR1QeZuQDVprvFUIllSKcYzkt4eUFfDn3g0Uf0P7igFtmV3w0TQAHzE7yAY0A5Sj0elpsezj6GhVN7akV/ZAZ949jInxopPuc2XPP3Gaa27LmxK65xuibq78IlARES9HDT4rthaFwrIYunVjh3UyK7CVyzh+F8Nla/DnXT0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=SeQe9fjt; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260116050408epoutp012250f33c1425b747e4b0023e153a8ce2~LHZ9aT1fI0865108651epoutp018
	for <ceph-devel@vger.kernel.org>; Fri, 16 Jan 2026 05:04:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260116050408epoutp012250f33c1425b747e4b0023e153a8ce2~LHZ9aT1fI0865108651epoutp018
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768539848;
	bh=krAGPeF4wfoAiMqvkgkDJ5nMQrHjszMZrxmFp3yODaY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SeQe9fjtxm3wWPuiFeYxSGRGOU9nIbvIcgNNg3ABt1+y4ih1ygRZhNrV7EDDQ9rjo
	 xPB+cE6AAm5qhLQx9JGq6J3aM+FmXh3XeErf6wPptk5p7wkO1IdvMrgUuss5FqhprK
	 XLrlRqNFWDc4UzMA/d6GOdSRPAKzVFWFmZPqxuGA=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260116050408epcas5p4c3ff024eaccccf19f642a193f8d0709b~LHZ9G8tsj2317523175epcas5p4M;
	Fri, 16 Jan 2026 05:04:08 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.91]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dsnng5yJwz6B9mC; Fri, 16 Jan
	2026 05:04:07 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260116050007epcas5p337824534f52ca087a525b9c261452ea1~LHWdBYv_b2686326863epcas5p3m;
	Fri, 16 Jan 2026 05:00:07 +0000 (GMT)
Received: from node1.. (unknown [109.105.118.96]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20260116050007epsmtip1fb51ced0cdfea6322fe45947350e7810~LHWcJoAjv3231032310epsmtip1H;
	Fri, 16 Jan 2026 05:00:06 +0000 (GMT)
From: Qian Li <qian01.li@samsung.com>
To: idryomov@gmail.com, xiubli@redhat.com, ceph-devel@vger.kernel.org
Subject: RE: [PATCH] ceph: add support for multi-stream SSDs(such as FDP
 SSDs)
Date: Fri, 16 Jan 2026 20:41:34 +0800
Message-Id: <20260116124134.3914835-1-qian01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <F9170EA4-B6F9-4CED-853D-EB1B15D73583@dreamsnake.net>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260116050007epcas5p337824534f52ca087a525b9c261452ea1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116050007epcas5p337824534f52ca087a525b9c261452ea1
References: <F9170EA4-B6F9-4CED-853D-EB1B15D73583@dreamsnake.net>
	<CGME20260116050007epcas5p337824534f52ca087a525b9c261452ea1@epcas5p3.samsung.com>

Hi all,

Thank you for your valuable feedback on the initial patch.  
I've summarized your comments regarding FDP technology, 
the design of this patch, and the test results.
Below is a brief clarification covering these aspects 
and the current state of FDP support in the Linux kernel.

1. FDP Technology
Flexible Data Placement(FDP) is a new data placement technology 
has been merged in NVMe specification v2.1. It allows the host 
to control where data is written. FDP SSDs support directives that 
differentiate data lifetime and place data into separate streams 
to reduce write amplification(WAF). More and more vendors have 
been involved in FDP SSDs since 2024. 

The two most important concepts in FDP are Reclaim Unit(RU) 
and Reclaim Unit Handle(RUH). A device can be viewed as 
a collection of RUs. An RU provides the physical capacity for 
storing data and is also the single erasable unit used by the 
controller during Garbage Collection(GC). An RUH can be 
understood as a reference to an RU. 

In our test environment, the FDP SSD supports up to 8 RUHs, 
each pointing to a different RU. When writing data, 
each RUH directs the data to a separate RU.

In summary, the biggest advantage of FDP compared to conventional SSDs 
lies in the flexibility it provides to the host——enabling precise 
control over data placement into isolated RUs via RUHs. This feature 
allows developers to place data with similar lifetimes into the same RU. 
As a result, during GC, most data in an RU becomes invalid simultaneously, 
significantly reducing the amount of valid data that needs to be migrated. 
This greatly lowers write amplification and extends device lifespan.

2. Current Kernel Support for FDP
Since commit 449813515d3e(block, fs: Restore the per-bio/request 
data lifetime fields), both file systems(f2fs, ext4, btrfs) and the 
block layer in the Linux kernel have supported data lifetime fields. 
The key fields involved are i_write_hint in inode and bi_write_hint in bio.

In 2025, commit 38e8397dde63(nvme: use fdp streams if write stream 
is provided) extended the kernel driver and io_uring to support FDP feature. 
Notably, bi_write_stream is essentially redundant with bi_write_hint. 

links:
https://github.com/torvalds/linux/commit/449813515d3e
https://github.com/torvalds/linux/commit/38e8397dde63

3. FDP Support for Ceph
We position Ceph as a distributed file system that sits between 
applications and storage devices. This patch adds FDP support to Ceph, 
enabling it to acquire data lifetime hints from applications and 
reflect them in storage.

Specifically, we modified the CephFS kernel client and Ceph server 
to allow files to receive i_write_hint from the kernel inode, then 
assemble the hint into a message and send it over the network to the OSD. 
The OSD parses the message to obtain the data lifetime hint and uses 
it to direct data placement via FDP commands. Note that the data is 
ultimately written via io_uring.

The overall design can be simply represented as follow:

Client --> ceph_inode_info --> ceph_osd_request --> ceph_msg
			    ^
			    |
			  socket
			    |
			    v
Server -->  MODOp message --> OpRequest --> OpContext --> PGTransaction 
--> ObjectStore::Transaction --> BlueStore::queue_transactions 
--> aio_write --> io_uring

This patch doesn't focus on specific objects, but instead sets 
a lifetime hint when a file is opened and sends it to the server 
in the form of a message, which ultimately guides FDP data placement. 
Since the Linux kernel file system already supports FDP feature, 
we chose to implement this in the CephFS kernel client.

4. Test Results
we conducted comparative testing of ceph on conventional SSDs 
versus FDP SSDs, focusing on WAF metric.

To measure WAF, we first performed sequential writes of multiple large files, 
filling the disk to over 90% capacity (the disk is 8TB), 
and then performed multiple random writes.

We used FIO((which already supports FDP)) for testing, 
with FDP configured to use six streams (0–5). 
When testing the FDP SSD, user data was categorized into 
four lifetime hints—short, medium, long, and extreme——
and each hint was written into a separate stream (streams 2–5). 
All remaining data was directed to stream 0, while stream 1 was left unused.

We conducted multiple tests with BlueStore. 
When using conventional SSDs, WAF reached as high as 1.91 or even 2, 
while with FDP SSDs, WAF was between 1.09 and 1.01. 
When the WAF of conventional SSDs is 1.91 
and the WAF of FDP SSDs is 1.09, the WAF is reduced by 42.9%.
In all test cases, when Ceph used FDP feature, WAF was close to 1, 
indicating that the device had minimal or no write amplification.

In summary, when Ceph supports FDP, it can achieve significant benefits 
in terms of write amplification.

>> 
>> As far as I know, FDP SSD itself cannot recognize data lifetime. This device is stupid enough. It needs to receive the hints from application or file system to distribute data in different streams based on "temperature" hints.
>
>That’s the idea! QLC and eventually PLC SSDs have inherently low endurance so novel methods are advantageous to make the best use of the available PE cycles.  
>

Yes, the FDP needs to receive temperature hints from the upper layer.
For details, please refer to [1. FDP Technology] above.

>> 
>>> It
>>> provides multiple streams to isolate different data lifetimes.
>>> Write_hint support in fs and block layers has been available since
>>> commit 449813515d3e ("block, fs: restore per-bio/request
>>> data lifetime field").
>>> This patch enables the Ceph kernel client to support
>>> the data lifetime field and to transmit the write_hint
>>> to the Ceph server over the network. By adding the write_hint to
>>> Ceph and passing it to the device, we achieve lower write
>>> amplification and better performance.
>> 
>> What is your prove that you can achieve lower write
>> amplification and better performance? Do you have any benchmark
>> results?
>
>My read is that this is enablement for emerging devices, and that benching and code refinement will follow as devices become available to mortals.  

We compared the WAF of Conventional SSDs and FDP SSDs. 
The WAF of FDP is close to 1.
For details, please refer to [4. Test Results] above.

>
>> . If it is small file(s), then one object
>> could receive multiple files with various temperature hints.
>
>I think RADOS doesn’t work that way.  In fact this code aims to achieve the opposite.  By grouping data with similar projected modification / deletion / TRIM timeframes, the firmware can reorder, buffer, and coalesce operations. A NAND page grouping a dozen small RADOS objects that get modified with a single PE cycle is favorable compared to distributing them around a dozen NAND pages and a dozen PE cycles.  That’s a substantial reduction in write amp, especially for a coarse IU, which in turn enables the cost and capacity advantages of even larger IUs.  
>
>> . Also, replication and redistribution algorithms
>> can move and shift data among OSDs that complicates data distribution a lot.
>
>This code would seem to work within a given OSD, so my sense is that rebalancing is moot.  
>
>> then OSD will have a complete mess of these hints for objects.
>
>That’s the idea! So that hot, warm, tepid, and cold data are grouped together, This will reduce the dynamic of RMW cycles for short-lived data dragging along longer-lived data.  Longer-lived data will experience few or no superfluous RMW / PE cycles.  This is somewhat akin to ensuring partition alignment.
>
>FDP / NDP SSDs will tend to be large SKUs with coarse IU.  Coarse IU improves the component economics by provisioning < 1GiB of FTL DRAM per TiB of NAND, otherwise the limited performance and endurance of QLC and PLC devices is harder to justify with a slimmer cost advantage.  A coarse IU also enables fitting all the dies into the form factor.  Consider a putative 500 TB-class device, think you can fit 500 GB of DRAM with the NAND into E3.S or even U.2?
>
>
>> Also, object is a big piece of data (around 4MB)
>
>RADOS objects by default are *at most* 4MiB.  Depending on the usage modality and write patterns, they can be rather smaller, especially with the Fast EC code that avoids padding.  
>
>> and, as a result, if you write it sequentially
>
>Who is “you”? Via the IO blender effect, OSDs in almost all cases see a random write workload.  
>

This patch relies on the support for FDP in the Linux kernel's 
file system and driver, so it manages the lifetime of files. 
A hint is set for each file when it is opened.
For details, please refer to [2. Current Kernel Support for FDP] 
and [3. FDP Support for Ceph] above.


>> Secondly, as far as I can see, people
>> could use HDDs for Ceph clusters.
>
>Sure, if they don’t mind paying for 10-20 times the DC space and suffering burgeoning seek and rotational latencies.  Not to mention crossing your fingers for two months while the cluster slowly, painfully recovers from the loss of an OSD.  
>

With the development of AI, I believe that existing distributed 
file systems will gradually improve performance by updating their devices. 
HDDs may be the current situation, but SSDs will become more widespread.

>
>> And it means that FDP will be completely useless in such case.
>
>I don’t follow, this seems like a non sequitur.  
>
>> Otherwise, this patch is completely useless.
>
>Please be civil. I don’t understand the pharmacokinetics of GLP-1 agonists or tamulosin but both are rather useful.  

Looking forward to your further thoughts!
Best regards,

Qian Li

