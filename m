Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB5A566F67
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Jul 2022 15:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbiGENiG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 5 Jul 2022 09:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiGENhx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 5 Jul 2022 09:37:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D9E7BD32
        for <ceph-devel@vger.kernel.org>; Tue,  5 Jul 2022 05:59:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DAFF6066C
        for <ceph-devel@vger.kernel.org>; Tue,  5 Jul 2022 12:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E34C341C7;
        Tue,  5 Jul 2022 12:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657025944;
        bh=kcKOBUp7SMF5hh49VaVQ8WjkcectkQbDg5Gc6hm6AjM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iQMCCwvfUgiYDKeK77vkIaGcLwJcTlyOTQ4fZ7TVmnzp0F6Xl2o3zY9cj9j50nbqg
         3WQAE/GohkhXcXl0RzwJK7gLf+kd3tLfGuy538CAJU33A9UKZx5eqBNNm1x5eBV+ix
         Y+gMHItPZQxrAa61lTqPulVphSu9DAA3/eNJW2MMSv8fz1JKmFbq5j8VsJyrFAvvc9
         Fa8Iwy6T7XDfcH2Z97OVOwzHfBOiDBJ4sllo6Xr2dyzT480leG4eHcju764XO1mWsJ
         ch9WdJZO4vQ2gjSff/1wGGhKHLanNSXNDN5UtFAy3J5yF0gQGyJlpe6uIn1C7HtrFb
         OWUcgkuHq78oQ==
Message-ID: <a28932b4f81766e9e1fc22f008f527f578af91f3.camel@kernel.org>
Subject: Re: [PATCH v3 0/2] libceph: add new iov_iter msg_data type and use
 it for reads
From:   Jeff Layton <jlayton@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org
Date:   Tue, 05 Jul 2022 08:59:03 -0400
In-Reply-To: <YsKBGq99GNpL5jMu@infradead.org>
References: <20220701103013.12902-1-jlayton@kernel.org>
         <YsKBGq99GNpL5jMu@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, 2022-07-03 at 22:56 -0700, Christoph Hellwig wrote:
> On Fri, Jul 01, 2022 at 06:30:11AM -0400, Jeff Layton wrote:
> > Currently, we take an iov_iter from the netfs layer, turn that into an
> > array of pages, and then pass that to the messenger which eventually
> > turns that back into an iov_iter before handing it back to the socket.
> >=20
> > This patchset adds a new ceph_msg_data_type that uses an iov_iter
> > directly instead of requiring an array of pages or bvecs. This allows
> > us to avoid an extra allocation in the buffered read path, and should
> > make it easier to plumb in write helpers later.
> >=20
> > For now, this is still just a slow, stupid implementation that hands
> > the socket layer a page at a time like the existing messenger does. It
> > doesn't yet attempt to pass through the iov_iter directly.
> >=20
> > I have some patches that pass the cursor's iov_iter directly to the
> > socket in the receive path, but it requires some infrastructure that's
> > not in mainline yet (iov_iter_scan(), for instance). It should be
> > possible to something similar in the send path as well.
>=20
> Btw, is there any good reason to not simply replace ceph_msg_data
> with an iov_iter entirely?
>=20

Not really, no.

What I'd probably do is change the existing osd_req_op_* callers to use
the new iov_iter msg_data type first, and then once they all were you
could phase out the use of struct ceph_msg_data altogether.
--=20
Jeff Layton <jlayton@kernel.org>
