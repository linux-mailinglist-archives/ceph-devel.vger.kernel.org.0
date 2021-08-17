Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654743EEEF2
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Aug 2021 17:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238131AbhHQPKH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Aug 2021 11:10:07 -0400
Received: from llsc497-a17.servidoresdns.net ([82.223.190.48]:42188 "EHLO
        llsc497-a17.servidoresdns.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237052AbhHQPKH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 11:10:07 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Aug 2021 11:10:07 EDT
Received: from [192.168.43.50] (unknown [2.140.11.83])
        by llsc497-a17.servidoresdns.net (Postfix) with ESMTPA id 4GpvPZ3p6Dz2t6r;
        Tue, 17 Aug 2021 17:01:38 +0200 (CEST)
From:   =?UTF-8?Q?Ignacio_Garc=c3=ada?= <igarcia@livemed-spain.com>
To:     ceph-devel@vger.kernel.org, ceph-users@lists.ceph.com
Subject: hard disk failure monitor issue: ceph down, please help
Message-ID: <79c7cf51-64fb-d94e-9950-53c5c1580e53@livemed-spain.com>
Date:   Tue, 17 Aug 2021 17:01:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: es-ES
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi friends, we are a SME company that mounted a ceph storage system 
several months ago as a proof of concept, then, as we liked it, started 
to use it in production applications and as a corporative filesystem, 
postponing taking the adequate measures to have a well deployed ceph 
system (3 servers instead of 2, 3 object replica instead of 2, 3 
monitors instead of 1...). The disaster has happened before than that 
and we are desperately asking for your help in order to know whether we 
can recover the system or at least the data.

In short, the boot disk of the server where the only monitor was running 
has failed, containing as well the deamon monitor data (monitor map...). 
We will appreciate any help you can offer us before we break anything 
that could be recoverable trying non expert solutions.

Following are the details, thank you very much in advance:


* system overview:


2 commodity servers, 4 HD each, 6 HDs for ceph osds

2 replica; 1 only monitor

server 1: 1 mon, 1 mgr, 1 mds, 3 osds

server 2: 1 mgr, 1 mds, 3 osds

ceph octopus 15.2.11 containerized docker deamons; cephadm deployed

used for libvirt VMs rbd images, and 1 cephfs


* the problems:


--> HD 1.i failed, then server 1 is down: no monitors, server 2 osds 
unable to start, ceph down

--> client.admin keyring lost


* hard disk structure details:


- server 1:            MODEL    SERIAL    WWN

1.i)    /dev/sda    1.8T  WDC_WD2002FYPS-0     WD-WCAVY7030179 
0x50014ee205e40c09

--> server 1 boot disk, root, and ceph deamons data (/var/lib/ceph, etc) 
--> FAILED

1.ii)    /dev/sdc    7.3T  WDC_WD80EFAX-68L    7HKG3MEF 0x5000cca257f0b152

--> Osd.2

1.iii)    /dev/sdb    7.3T WDC_WD80EFAX-68L    7HKG6H3F 0x5000cca257f0bc0f

--> Osd.1

1.iv)    /dev/sdd    1.8T WDC_WD2002FYPS-0     WD-WCAVY6926130 
0x50014ee25b180bf3

--> Osd.0



- server 2            MODEL    SERIAL    WWN

2.i)    /dev/sda    223,6G  INTEL_SSDSC2KB24 BTYF90350ENF240AGN    
0x55cd2e4150390704

--> server 2 boot disk, root, and ceph deamons data (/var/lib/ceph, etc)

2.ii)    /dev/sdb    7,3T  HGST_HUS728T8TAL    VAGUR01L 0x5000cca099cbafde

--> Osd.3

2.iii)    /dev/sdc    7,3T  HGST_HUS728T8TAL    VGG2G7LG 0x5000cca0bec11e37

->  Osd.4

2.iv)    /dev/sdd    1,8T  WDC_WD2002FYPS-0    WD-WCAVY7261411 
0x50014ee2064414f2

-->  Osd.5


Ignacio G,

Live-Med Iberia


