Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89872CD46B
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Dec 2020 12:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730089AbgLCLQp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Dec 2020 06:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728546AbgLCLQp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Dec 2020 06:16:45 -0500
X-Greylist: delayed 900 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Dec 2020 03:16:04 PST
Received: from smtp.bit.nl (smtp.bit.nl [IPv6:2001:7b8:3:5::25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9EFC061A4D
        for <ceph-devel@vger.kernel.org>; Thu,  3 Dec 2020 03:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bit.nl;
        s=smtp01; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:From:To:Sender:Cc;
        bh=SqremlJT4soh5hH5O4Hlff01P3ex40DlkTVlsFhBNo0=; b=1efmRgFjAr3RBP1UE0BTvZjav9
        Y2YXHPNVpAUaVHz4q19bBgfKYRnHNnFNBLqzAzSZTVUUEiXnwHNg1uwOvx4yaGfvIf0BbFatDfd5/
        x60OURYLa0fOknYB7dwNogqNxLk28NgCNdQ+9etG+dcE4hKyi4gtvzEXoj2qKNwS1VYG2V/zrb8Tf
        q3Lky8W689tdffO2JyC3gFE3NQOxMgPC5NvO61KGygu9bEIJ2AdSGKsD4+kYdkG9iG3y86Rw8StfZ
        gc1TRFgWAqSwvwMf64tFbKxRpR0rZZ24mt5SoC++4gn49b6/lhSseClwtQ2yWDLKP2ESA5GhezxmB
        imMp5IuQ==;
Received: from [2001:7b8:3:1002::1001] (port=32018)
        by smtp1.smtp.dmz.bit.nl with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <stefan@bit.nl>)
        id 1kkmM8-0002pu-R3
        for ceph-devel@vger.kernel.org; Thu, 03 Dec 2020 12:01:00 +0100
To:     Ceph Development <ceph-devel@vger.kernel.org>
From:   Stefan Kooman <stefan@bit.nl>
Subject: Investigate busy ceph-msgr worker thread
Message-ID: <9afdb763-4cf6-3477-bd32-762840c0c0a5@bit.nl>
Date:   Thu, 3 Dec 2020 12:01:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

We have a cephfs linux kernel (5.4.0-53-generic) workload (rsync) that 
seems to be limited by a single ceph-msgr thread (doing close to 100% 
cpu). We would like to investigate what this thread is so busy with. 
What would be the easiest way to do this? On a related note: what would 
be the best way to scale cephfs client performance for a single process 
(if at all possible)?

Thanks for any pointers.

Gr. Stefan
