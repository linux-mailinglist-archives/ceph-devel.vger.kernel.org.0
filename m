Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4257B218B9
	for <lists+ceph-devel@lfdr.de>; Fri, 17 May 2019 15:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbfEQNA2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 May 2019 09:00:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:36958 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728407AbfEQNA2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 17 May 2019 09:00:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 75014AF59;
        Fri, 17 May 2019 13:00:27 +0000 (UTC)
Subject: Re: Bluestore onode improvements suggestion.
To:     =?UTF-8?B?0JLQuNGC0LDQu9C40Lkg0KTQuNC70LjQv9C/0L7Qsg==?= 
        <vitalif@yourcmc.ru>, ceph-devel <ceph-devel@vger.kernel.org>,
        Sage Weil <sweil@redhat.com>
References: <796fe4f9-ff11-647c-8da9-e85417052a53@suse.de>
 <5BC1A934-3693-4761-BD5B-380A07715DE2@yourcmc.ru>
From:   Igor Fedotov <ifedotov@suse.de>
Message-ID: <0e2344e6-d2a0-3b79-3ea5-eb083a10bbf8@suse.de>
Date:   Fri, 17 May 2019 16:00:13 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <5BC1A934-3693-4761-BD5B-380A07715DE2@yourcmc.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Because this ends up in a single pretty large rocksdb record which is 
expensive to modify. And the latter happens on the each write access to 
this onode.

On 5/17/2019 2:42 PM, Виталий Филиппов wrote:
> Why is it required to split blobs at all? Why not just write 4mb when 
> the client writes 4mb?
> -- 
> With best regards,
> Vitaliy Filippov 
