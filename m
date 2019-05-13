Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A92B1BB4F
	for <lists+ceph-devel@lfdr.de>; Mon, 13 May 2019 18:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbfEMQvw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 May 2019 12:51:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55540 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbfEMQvv (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 May 2019 12:51:51 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9771D308222F;
        Mon, 13 May 2019 16:51:51 +0000 (UTC)
Received: from [10.10.122.199] (ovpn-122-199.rdu2.redhat.com [10.10.122.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29B7A608AC;
        Mon, 13 May 2019 16:51:50 +0000 (UTC)
Subject: Re: Ceph iscsi targets on ubuntu
To:     Ugis <ugis22@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        florian@florensa.me
References: <CAE63xUOEcQhUnys1Phq-3-+BmN-C7gSd9pHv6vRGy1MW1=TnKQ@mail.gmail.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <5CD9A0A6.3060707@redhat.com>
Date:   Mon, 13 May 2019 11:51:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.6.0
MIME-Version: 1.0
In-Reply-To: <CAE63xUOEcQhUnys1Phq-3-+BmN-C7gSd9pHv6vRGy1MW1=TnKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 13 May 2019 16:51:51 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 05/09/2019 07:42 AM, Ugis wrote:
> Hi,
> 
> Going for new ceph cluster, wishing to deploy iscsi gateways from the beginning.
> 
> Reviewed docs, there still is no sign that iscsi gateways are
> available on Ubuntu
> http://docs.ceph.com/docs/master/rbd/iscsi-targets/
> 
> Is this still true or there are descriptions how to setup iscsi
> targets on ubuntu somewhere outside official docs? Of course, this
> should flawlessly integrate with Nautilus dashboard.
> 

It is still not fully supported because there are some rpm/yum calls and
other red hat/suse specific quirks.

