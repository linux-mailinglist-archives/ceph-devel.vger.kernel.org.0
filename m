Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3481034878
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 15:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbfFDNU0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Tue, 4 Jun 2019 09:20:26 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:53773 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727153AbfFDNU0 (ORCPT
        <rfc822;groupwise-ceph-devel@vger.kernel.org:0:0>);
        Tue, 4 Jun 2019 09:20:26 -0400
Received: from emea4-mta.ukb.novell.com ([10.120.13.87])
        by smtp.nue.novell.com with ESMTP (TLS encrypted); Tue, 04 Jun 2019 15:20:25 +0200
Received: from localhost (nwb-a10-snat.microfocus.com [10.120.13.201])
        by emea4-mta.ukb.novell.com with ESMTP (TLS encrypted); Tue, 04 Jun 2019 14:20:04 +0100
Date:   Tue, 4 Jun 2019 15:20:03 +0200
From:   Jan Fajerski <jfajerski@suse.com>
To:     ceph-devel <ceph-devel@vger.kernel.org>
Subject: MDS refuses startup if id == admin
Message-ID: <20190604132003.4z6oxllc2ghcncle@jfsuselaptop>
Mail-Followup-To: ceph-devel <ceph-devel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: NeoMutt/20180716
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi list,
I came across some strange MDS behaviour recently where it is not possible to 
start and MDS on a machine that happens to have the hostname "admin".

This turns out to be this code 
https://github.com/ceph/ceph/blob/master/src/common/entity_name.cc#L128 that is 
called by ceph-mds here 
https://github.com/ceph/ceph/blob/master/src/ceph_mds.cc#L116.

Together with the respective systemd unit file (passing "--id %i") this prevents 
starting an MDS on a machine witht he hostname admin.

Is this just old code and chance or is there a reason behind this? The MDS is 
the only daemon doing that, though I did not check for other but similar checks 
in other daemons.

Best,
Jan

-- 
Jan Fajerski
Engineer Enterprise Storage
SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
