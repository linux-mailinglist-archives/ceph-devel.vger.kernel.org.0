Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15462542DDC
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jun 2022 12:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237143AbiFHKae (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jun 2022 06:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237858AbiFHK31 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jun 2022 06:29:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13ED6B4B7
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jun 2022 03:19:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88F25B826B8
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jun 2022 10:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB93AC34116;
        Wed,  8 Jun 2022 10:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654683549;
        bh=Otf6dFyekHK14C8z/ssthJqQauL8fxNqAZL4k2hoBGA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Gjng0XIcsBXSyQ1Gz3w2BUa28jpC0LEu+X1MgnBWtwFfP6U+gyK3chfPMiMRh/7ek
         Ph1GubXFJ/hCtblOLJ9yCaAArf7DXTvf4H3s4WCZFzCPKpsN4YDQcNBSS8h1ekB1ue
         1vbQewNbc/KXRsESMlvQ6xkxE1dlTPOUjOM7jszNZQbx7QzmC6zWX3nzyYpcFX/HnK
         t30c6Gl2otFpxs4CgjK8he7YN1AstiC9MuPW6iIJ0tuK7AC266us4omgPFpRIv9P9F
         mbRa7v063hA7gQRTY9GiT0ehq/Il4N18C9PnqUfm2tIAGISAnuShFHVVDSBdWhbd7v
         7R5o6GnOPa+Gw==
Message-ID: <a7c455aa0e96c1dbcbd8228ab6460d8acffe503f.camel@kernel.org>
Subject: Re: [PATCH] ceph: don't implement writepage
From:   Jeff Layton <jlayton@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org
Date:   Wed, 08 Jun 2022 06:19:07 -0400
In-Reply-To: <YqBDs+u6qUHOprMv@infradead.org>
References: <20220607112703.17997-1-jlayton@kernel.org>
         <YqBDs+u6qUHOprMv@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-06-07 at 23:37 -0700, Christoph Hellwig wrote:
> Do you have an urgent need for this?  I was actually planning on sending
> a series to drop ->writepage entirely in the next weeks, and I'd pick
> this patch up to avoid conflicts if possible.
>=20


No, there's no urgent need for this. I was just following Willy's
recommendation from LSF.

> Note that you also need to implement ->migratepage to not lose any
> functionality if dropping ->writepage, and comeing up with a good
> solution for that is what has been delaying the series.

Oh, I didn't realize that! I'll plan to drop this from our series for
now. Let us know if you need us to carry any patches for this.

Thanks!
--=20
Jeff Layton <jlayton@kernel.org>
