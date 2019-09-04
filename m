Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 854FEA7828
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Sep 2019 03:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbfIDBpE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Sep 2019 21:45:04 -0400
Received: from 195-159-176-226.customer.powertech.no ([195.159.176.226]:41492
        "EHLO blaine.gmane.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfIDBpE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 3 Sep 2019 21:45:04 -0400
Received: from list by blaine.gmane.org with local (Exim 4.89)
        (envelope-from <gcfcd-ceph-devel3-2@m.gmane.org>)
        id 1i5KM2-000IrB-K5
        for ceph-devel@vger.kernel.org; Wed, 04 Sep 2019 03:45:02 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     ceph-devel@vger.kernel.org
From:   Alex Litvak <alexander.v.litvak@gmail.com>
Subject: Nautilus 14.2.3 packages appearing on the mirrors
Date:   Tue, 3 Sep 2019 20:43:52 -0500
Message-ID: <qkn4so$odv$2@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
X-Mozilla-News-Host: news://new.gmane.org:119
Content-Language: en-US
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Sorry for the cross post but I think it is related to devs.

If it is a release it broke my ansible installation because it is missing librados2

https://download.ceph.com/rpm-nautilus/el7/x86_64/librados2-14.2.3-0.el7.x86_64.rpm (404 Not Found).

Please fix it one way or another.

