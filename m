Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A944135C2E
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jan 2020 16:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730662AbgAIPEh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 10:04:37 -0500
Received: from yourcmc.ru ([195.209.40.11]:40714 "EHLO yourcmc.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbgAIPEh (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 10:04:37 -0500
Received: from yourcmc.ru (localhost [127.0.0.1])
        by yourcmc.ru (Postfix) with ESMTP id 7541FFE0656;
        Thu,  9 Jan 2020 18:04:35 +0300 (MSK)
Received: from webmail.yourcmc.ru (localhost [127.0.0.1])
        by yourcmc.ru (Postfix) with ESMTP id 527C4FE00CB;
        Thu,  9 Jan 2020 18:04:35 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 09 Jan 2020 18:04:35 +0300
From:   vitalif@yourcmc.ru
To:     Roman Penyaev <rpenyaev@suse.de>
Cc:     ceph-devel@vger.kernel.org, ceph-devel-owner@vger.kernel.org
Subject: Re: crimson-osd vs legacy-osd: should the perf difference be already
 noticeable?
In-Reply-To: <a863f28906a908696de4a9ff10b3eb9a@suse.de>
References: <02e2209f66f18217aa45b8f7caf715f6@suse.de>
 <34d373cf1e08ed8480655969d0be63a4@yourcmc.ru>
 <a863f28906a908696de4a9ff10b3eb9a@suse.de>
Message-ID: <df92e5fc1ea9408af25c935cf5ed02b0@yourcmc.ru>
X-Sender: vitalif@yourcmc.ru
User-Agent: Roundcube Webmail/1.2.3
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

> Could you please share the link?

It was here 
https://www.youtube.com/channel/UCno-Fry25FJ7B4RycCxOtfw/videos but I'm 
not sure about what video it was.

> Hm, I can't prove even that.  So here is the output of pidstat while
> rbd.fio is running, 4k block only:

Yeah... funny :)
