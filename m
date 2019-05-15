Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 718C91E7FE
	for <lists+ceph-devel@lfdr.de>; Wed, 15 May 2019 07:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfEOFkB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 May 2019 01:40:01 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:45164 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfEOFkB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 15 May 2019 01:40:01 -0400
Received: by mail-pl1-f177.google.com with SMTP id a5so741145pls.12
        for <ceph-devel@vger.kernel.org>; Tue, 14 May 2019 22:40:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=fi/Evog88daeHng1VnFIzae06SFVqb+ytkGJieagqOE=;
        b=lKiU+D8aF2yIrhS5pe0mKckYQ89Ha5JlFbkjx1tqIqZzRXa+LSSNqMXYk4rv9U4mh3
         EDezBtGF03/sItWV8O1MWnZrqqaGP8lU0V3fJSYd+1FBElvpLSAvb0AzZHHIqNBOTD/G
         vHfbfmL0GVIM/8TH7xO0ExYvpRstNPxYBC8xcy9f0+YkR1+uf9sd0aL+kO6tg9ZTqMIj
         XDF1Leozm9U6fUsRRfflJeWZlY9B4fvTXjccbW4Vu7l5fyvHeicTABBdoOaTO+LxdDCE
         6eOCX1I+hlG8cuBT8n7pbV/Mwkg55TJHYu/9H3YdKWxXOn+rKarTPqI1crL6k+fGWKOV
         Lltg==
X-Gm-Message-State: APjAAAU8R3UjC0QMBmZxnAZt5RG6Hg0HyVmuhJYt+JLuWCzNEKLJle9P
        lq34tudptjOPV8qYacDdq+crJnx8q3Y=
X-Google-Smtp-Source: APXvYqzhJKFzXrUsnyLvk3W8RnAzf73IFHKm8y1/XV/JiJHt6Bi2HlzqmfMHCYCw34bNK3OLW4lOMQ==
X-Received: by 2002:a17:902:5acb:: with SMTP id g11mr40836533plm.198.1557898800208;
        Tue, 14 May 2019 22:40:00 -0700 (PDT)
Received: from [192.168.1.5] ([122.167.117.229])
        by smtp.gmail.com with ESMTPSA id t25sm1415433pfq.91.2019.05.14.22.39.59
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 22:39:59 -0700 (PDT)
To:     ceph-devel@vger.kernel.org
From:   Jos Collin <jcollin@redhat.com>
Subject: =?UTF-8?Q?Proposal_=e2=80=93_DaemonWatchdog?=
Message-ID: <1e522eba-fc1f-ccd3-97e6-106411b1ddeb@redhat.com>
Date:   Wed, 15 May 2019 11:09:57 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

This is a proposal for DaemonWatchdog improvements based on the bug: 
http://tracker.ceph.com/issues/11314. Sending it to ceph-devel for 
getting suggestions.

Current Functionality
---------------------
DaemonWatchdog watches the Ceph daemons for failures. If an extended 
failure is detected (i.e. not intentional), then the watchdog unmount 
file systems and send SIGTERM to all daemons. The duration of an 
extended failure is configurable with  watchdog_daemon_timeout. The 
watchdog_daemon_timeout (default value: 300) is the number of seconds a 
daemon is allowed to be failed before the watchdog barks (unmounting the 
mounts and killing all the daemons).

DaemonWatchdog was originally written for watching the mds (and mon) 
daemons for failures. It unmounts the mounted filesystems and kill the 
mds (and mon) daemons.

Proposed Improvement
--------------------
As per John's suggestion here: 
http://tracker.ceph.com/issues/11314#note-1, it would be better if we 
extend this functionality to watch the other daemons too like osd, mon, 
rgw and mgr and do the necessary action or logging (bark) when those 
daemons crashes. We need to make those improvements in watch() and 
bark() functions, so that if the daemon crashes unexpectedly, we detect 
it immediately rather than waiting a long time for a timeout of some 
kind. The bark() function should have different cases to handle 
different daemons crashing. The procedure to be executed for ‘mds’ case 
is present in the bark() function now. But we need to decide the 
procedures for ‘osd’, ‘mon’, ‘rgw’ and ‘mgr’ cases. I think killing the 
daemons and throwing/logging errors or maybe just throwing an error 
would be sufficient.

* At present the class DaemonWatchdog is written in mds_thrash.py, as it 
is specific for watching mds daemons. It would be better if we move it 
out of mds_thrash.py to be generic, to a new file 
qa/tasks/daemonwatchdog.py.

* The current code tries to watch the 'client'? 
(https://github.com/ceph/ceph/blob/master/qa/tasks/mds_thrash.py#L87). I 
have dropped this statement, as it is difficult to watch what the client 
is doing in general.

* There is a suggestion to add the DaemonWatchdog to ceph.py and have it 
always run whenever Ceph is "started".

Thanks,
Jos Collin
