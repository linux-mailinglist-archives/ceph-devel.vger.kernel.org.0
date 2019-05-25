Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE02E2A25C
	for <lists+ceph-devel@lfdr.de>; Sat, 25 May 2019 04:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfEYCNd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 May 2019 22:13:33 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:40105 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfEYCNd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 24 May 2019 22:13:33 -0400
Received: by mail-wm1-f48.google.com with SMTP id 15so10806462wmg.5
        for <ceph-devel@vger.kernel.org>; Fri, 24 May 2019 19:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:subject:to:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=4BJ1PDajeLC9aJNK76BTup5rli0mXkZ8MKNyiMVDOq0=;
        b=SKhbytVhVUuPmvSHr7MmUpuSORjLsE7cwy21R18IAUWl0ATT7OlXvDQODnLhjjJp4e
         XX0TvvLZ6dpijUtKtGF5K+y2+cgIADy20hMATyfMiHlO5fcRLeHQHtugyGnAw05z4GQs
         rWlC34664PaleqELcZIKdQX5tC6satqpE2/umDrV9gF5N710fwdww0ElfDGVuDhu+8J5
         n1PmB43pDLBsge07l5/1nRJKHHwxkSqvifXJMYUGz+OYSRMboNJ6HwLECKBh1gHAs7nq
         GBi988eo6+v7GTvicgNfa0TaKeO11eC61A5LucxME+XzxIx53XviE8f1SDcq4RcbXAeJ
         aMYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=4BJ1PDajeLC9aJNK76BTup5rli0mXkZ8MKNyiMVDOq0=;
        b=sMypIjYYsTQ3cDMS7/hXVNxvFC3TX8Mobf4g+5DnCV50tA3LNH9ueeXWOyII7rcBIc
         +FfVljxUuvOKnbeRNB5r/LlrO5rDZD7xJJDxPuGhYUbFxmTc1A8GDyGAkaaYtSvqESaG
         WlVYfQZCnhxRxwqg1H2hvDLsdoMHg3GaHy80Mb8GcehouL9NkALXkSnY9dfbwMTOcOCq
         yZOENIg8Bbhn5aay0Z6PZiR4VBUgakhy0rGHpUrjCwLLYNzMcrlAO86B9mC/BaOmh8Wq
         Enlc5JdHnQ+Jcq6w7AgPyVzfegnqp6Q+45EPrTYussiYDpB8VvvyoCWX8oS7iYmB9/9x
         6l1w==
X-Gm-Message-State: APjAAAWIOZCrjFjT2GfjbgLbyKfIPdA+evqU2K4pCwVqN2RjjAkV8+ZW
        7sGcXSipNx61mSKRJUWHvRmbVbwb
X-Google-Smtp-Source: APXvYqyA8Cm05Y6sUSuG6syB3iK+UE7xd+tSId6doLZf/iL95llfrCW0+82nHT7NQTFHSGB+pjQPgg==
X-Received: by 2002:a05:600c:21d7:: with SMTP id x23mr18426331wmj.105.1558750410204;
        Fri, 24 May 2019 19:13:30 -0700 (PDT)
Received: from [192.168.43.20] (ip1f10d9fc.dynamic.kabel-deutschland.de. [31.16.217.252])
        by smtp.gmail.com with ESMTPSA id p17sm4631928wrq.95.2019.05.24.19.13.28
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 19:13:29 -0700 (PDT)
From:   Owen Synge <osynge@googlemail.com>
Subject: Keynote: What's Planned for Ceph Octopus - Sage Weil -> Feedback on
 cephs Usability
To:     ceph-devel@vger.kernel.org
Message-ID: <9607e2ac-ce55-60af-7b84-609783778ee2@googlemail.com>
Date:   Sat, 25 May 2019 04:13:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dear Ceph team,

I have been watching Sages 5 these for octopus, and a love the themes, 
and all of Sages talk.

Sages talk mentioned cluster usability.

On 'the orchestrate API' slide, sage slides talk about a "Partial 
consensus to focus efforts on":

(Option) Rook (which I don't know, but depends on Kubernetes)

(Option) ssh (or maybe some rpc mechanism).

I was sad not to see the option

(Option) Support a common the most popular declarative 
puppet/chef/cfengine module.

I think option (ssh) exists only because work has been invested in 
complex salt and ansible implementations, but that never seem to reduce 
in complexity. I propose we chalk it down to mistakes we made and gain 
some wisdom why option (ssh) took much more effort than expected, and 
learn from Option (Rook).

I think option (Rook) is a very good idea, as it works on sounds ideas I 
have seen work before.

I understand that ceph should not *only* depend on anything as complex 
as Kubernetes as a deployment dependency, even if it is the best 
solution. I may not want to run some thing as complex as Kubernetes just 
to run ceph.

I would have liked to see on the slides:

(Option) Look how to get Rook's benefits without Kubernetes

The rest of the email explains how I think ceph should best be 
configured without Kubernetes in a ceph like way.

I believe Rook's dependency Kubernetes, provides an architecture based 
on a declarative configuration and shared service state makes managing 
clusters easier. In other words Kubernetes is like service version of 
cephs crushmap which describes how data is distributed in ceph.

To implement (Names can be changed and are purely for illustration)
"orchestratemapfile" -> desired deployment configfile
     'orchestratemap' -> compiled with local state orchestratemapfile

     'liborchestrate' -> shares and executes orchestratemap

So any ceph developer can understand, just like the crushmap is 
declarative and drives data, The "orchestratemap" should be declarative 
and drive the deployment. The crushmap is shared state across the 
cluster, the orchestratemap would be a shared state across the cluster. 
A crushmap is a compiled crushmapfile with state about the cluster. A 
orchestratemap is compiled from a orchestratemapfile with state about 
the cluster.

Just like librados can read a crushmap and speak to a mon to get cluster 
status, and drive data flow, liborchestrate can read a orchestratemap, 
and drive the stages of ceph deployment, A MVP* would function with 
minor degradation even without shared cluster state. (ie no orchestratemap).

A good starting point for the orchestratemapfile would be the Kubernetes 
config for rook, as this is essentially a desired state for the cluster.

If you add the current state locally into the orchestratemap when 
compiling the orchestratemapfile, All desired possible operations can be 
calculated by each node using just the orchestratemap and the current 
local state independently. All the operations that must be delayed due 
to dependencies in other operations can also be calculated for each 
node, this avoids, retry, timeouts, and instantly reduces error handling 
and allows for ceph to potentially, save the user from knowing that more 
than one deamon is running to provide ceph, staged upgrades,practice 
self healing at the service level, guide the users deployment with more 
helpful error messages, and many other potential enhancements.

It may be argued that Option (ssh) is simpler than implementing an 
"orchestratemap" and liborchestrate that reads it, and I argue Option 
(ssh) is simpler for a test grade MVP, but for a production grade MVP 
solution I suspect implementing an "orchestratemap" and liborchestrate 
is simpler due to simpler synchronization, planning and error handling 
for management of ceph, just like the crushmap simplifies 
synchronization, planning and error handling for data in ceph.

Good luck and have fun,

Owen Synge


* I once nearly finished an orchestratemapfile to ceph configuration 
once (no shared cluster state), and the bulk of the work was 
understanding how each ceph daemon interact with the cluster during 
boot, and commands to manage the demon. Only the state serialization, 
comparison and propagation where never completed.

