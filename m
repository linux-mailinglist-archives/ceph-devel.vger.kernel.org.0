Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3785A3A867F
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Jun 2021 18:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhFOQbD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Jun 2021 12:31:03 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63363 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhFOQbB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Jun 2021 12:31:01 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210615162855euoutp01ad6e86ce042d5d9a8c1d0cc8b7f986dd~IzlYzcF-E1226212262euoutp01G;
        Tue, 15 Jun 2021 16:28:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210615162855euoutp01ad6e86ce042d5d9a8c1d0cc8b7f986dd~IzlYzcF-E1226212262euoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623774535;
        bh=xlgLokA1E+ZL2R6HWaDfu9TCOox/AjjaAxkG29EvyOY=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=eXGCngLhbKBWvmZD1q//dCrYCLvpvjCmxVxNpM5R2hkZhZSuHLYtvDq66CpJGuZ3t
         +vz3mAnsk7oXEfcQSrZKNgm3jjHeiaxibNQPz/dGglAcqD9fcYrhpOs5eMKI9Lc5/z
         b6NF33kQ0+nbbTLJD9nkxi3x7ulcBsg/5Oruv6pA=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210615162854eucas1p16fe3d1cb9712f22c61caf1af21eda61c~IzlYcZM1U2673626736eucas1p1h;
        Tue, 15 Jun 2021 16:28:54 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 78.59.09439.645D8C06; Tue, 15
        Jun 2021 17:28:54 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210615162854eucas1p12f7975e37d474ac5ffdb532fa21ef58b~IzlX3jd6f1146211462eucas1p19;
        Tue, 15 Jun 2021 16:28:54 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210615162854eusmtrp1de18538b70433169cba9c508ea4d3c0d~IzlX2F6VP0369503695eusmtrp1k;
        Tue, 15 Jun 2021 16:28:54 +0000 (GMT)
X-AuditID: cbfec7f5-c1bff700000024df-f1-60c8d5467e58
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 5B.55.08705.645D8C06; Tue, 15
        Jun 2021 17:28:54 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210615162852eusmtip2560d33f2ab723e29cbde1a513bd9cbf2~IzlWL851d0102301023eusmtip2f;
        Tue, 15 Jun 2021 16:28:52 +0000 (GMT)
Subject: Re: [PATCH 09/30] mtd_blkdevs: use blk_mq_alloc_disk
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Justin Sanders <justin@coraid.com>,
        Denis Efremov <efremov@linux.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Tim Waugh <tim@cyberelk.net>,
        Geoff Levand <geoff@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        nbd@other.debian.org, linuxppc-dev@lists.ozlabs.org,
        ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <7f98a37c-281c-bff6-6126-a65feadcb6ca@samsung.com>
Date:   Tue, 15 Jun 2021 18:28:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210615155817.GA31047@lst.de>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0xTZxzNd+/tvS1Z8VrZ+o25bKkb2ajA2HR+m0D2MO4mLoaMbVkMBjq4
        K4TnWjpASaxIhBEnCBJKGUWQAuPlChXEzgdvWS0YqItAxcEoRAoOeQ4VGPTixn/n9zvnl3PO
        l4+Pi+6S7vzI2ARWESuLlpAuRGPncq/Xwbu3Qt8p7pOi6vtZJDJoLvFQfmUTgWYGcjB07VEh
        D1l/NwFU9jAA3dEu8lCj+VcKOXRVAP1S3YGhB7p0EpX3zWFouv48gZ6N+CKr2gOVX7QDdG1Q
        itrXsgAypZZTKLvkFI6eLq3y0FR3KYXa0q/z0NqTSR56aq/F0EhnNY5ym6cA0vRe5KHThgWA
        RvUVOFqzzFCowqIj0ZIxF/tIwuhqjjOO3GzAdD+8TTAdbS0U0zLaSjLN2vsU01DpyZinbBjT
        b1ExY9Z8jMkuvQmYhrITTO69CsD0akoA0zZjJRjTgJoMfPmIi184Gx35A6vwCQh1iZhrWMLi
        ewRJjpxdajBPZQIBH9J74Jq+yIlFdCWA2m5VJnBZx/MAdua1A26YA7DW1og9v+g4m0dwRAWA
        mqbqTdVjAIsnOsgN1Q7aH47W9fA2sBstgfZJi1OE0+0CaD+rdhIk7QszpzOdB0I6APbo0pxB
        CPpN2F7A2b1Ih8G/dRoep9kOuwvGiA0soHfD2eZ+pwanX4NN0z/jHBbDwbFibMMM0lMucF7r
        4HG5D8CGqtrNDjvgZJdx8wV2QnPuGYI7OAXgSE8txQ1nAOxP1QBOtR/aep6sR+WvW7wNL131
        4dYfw7TMK/jGGtKu8N70di6EK8xpzN9cC2HGaRGn9oDarrr/bFvu9OHZQKLdUk27pY52Sx3t
        /74XAFEFxKxKGSNnle/FsoneSlmMUhUr9w6Li6kH6z/fvNq1cAVUTj72bgUYH7QCyMclbkIv
        5a1QkTBclnyMVcSFKFTRrLIVvMInJGLh1cs1ISJaLktgo1g2nlU8ZzG+wF2N8b/ojlCS6vEM
        g8fioiFO3275NP5DP0/tzbLe0tKaurb6l3YOCwdXw919tr0furB/KIAJC8rbK04xXKZwkvLf
        VeD/ZWSYIiEey/+aHTB77JOH7wt+K2V+fCJyaHy4f2Xl3bwjzX+JjxmlwT8dTjq0/I8+LrrR
        nhJSha96fTd0/MTKs9n0oOU477brS0vuUXq35cIXTEbbJyUniwJnv/WQfmPyPZBsrX/96MTR
        UteMom3ewbU5r0pVs3sGqaiOyKSUR0mWc3+8IUgd96+DfiLpg8+SrLOK6IQ/s8wnZ0yFZcuJ
        H1B7E39ssnUG7k4+d+h7ufvwVJmY+S3tRtBt4+fn5Te+ckgIZYTM1xNXKGX/Av4MyY1oBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTZxiH851LLxjcWYFwYC4zdSwGR6Hc/Eq0OGeWE5dNxszINknbwRko
        l7JeVLYFqg4YyG2UjVpHEQstFiaXThQbVIqgXddqZjcBxxwdjXJTJkyGEhktLuG/X/J7njfv
        m7wslHMPD2Xtz1XQslxJNpfhh9mfXfsj4q1fr4ujNL0s2DpaxYCdmnYc1rWcx+DscA0Cex+c
        xKHrJwuATRNCeFP7GIfd9g4mnNKZADzTOoDAu7oSBjT8MofAma5aDC6N8aFL9Ro06D0A9o5s
        gVeXqwC0HDUwYXXjMRQ+XXiGw2nbaSbsL7mEw+Unkzh86vkBgWODrShU90wDqLmhx2Fx5z8A
        upuNKFx2zDKh0aFjwIUf1cgOLqVr+4KaUlcDyjbxM0YN9PcxqT63lUH1aEeZlLklnLJP/45Q
        txxKatxVh1DVp68AytxUSKmHjIC6oWkEVP+sC6MswypGUshHvG0yqVJBb8yUyhXbuR/zYTSP
        L4C86FgBjx+zNTUhOo4bKdyWTmfvP0jLIoViXuaceQHJc7IPT9VsUoF5Zhlgs0gilhyo/BYr
        A34sDtEMyEsTndhqsYG0fafCV3MAufRbGWMVeghIy8lyxFsEENtJ91mnDwokuKRn0gG8EEoM
        skmLbRx4Cw5xDCHP/lXgzQyCT5bNeCexWf6EkHTqvvKtgRFh5NUT3b6hQUQaudhe8px5kbSd
        GPdtxCZeJx/13PIxKBFP6sxj6Gp+hTw/8/3zHEyOjDcg1YCjXaNr1yjaNYp2jXIKYCYQSCvl
        ORk5cj5PLsmRK3MzeGnSnC6w8nHdg4vmC0A3+TfPChAWsAKShXID/SPk18Uc/3RJ/ue0TCqS
        KbNpuRXErdzzDRoalCZdedlchYgfHxXHj40XRMUJ4mO4wf7n6ttEHCJDoqCzaDqPlv3vISx2
        qArpLiodnRUl6Yt2V1Ym73FFBK5HghqNh24brIrL8x1FAWHrNzVcnk95o+ndr+vd9h3Hg6OT
        qx6uO9Di9+WdwdK34/SeT4YP1A2d2vXOYIEO73tgOkLd/OCwhxexoaP/ftu997pS249O8Nxd
        0hD1S4lbR9RRhxZl3aXJphlx4IWCcIH+eMW+hNQEJ8YqTLwi3lhjyGquL85IZAsNIWE785Ne
        tW1uv5i/+czdf+/YPl26LX5sPacpRxMqdoYPDX8o+uxNtFbFdrTmVdQ+mUvZtzdm3V7No13a
        g3nq+j3qF94HLx/xa2pIp5hZ14QpkVBN2Jwm+5Y/NbXGwnIZfbE4UWPD7rdxMXmmhB+OyuSS
        /wCAOdbc+gMAAA==
X-CMS-MailID: 20210615162854eucas1p12f7975e37d474ac5ffdb532fa21ef58b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210615154746eucas1p1321b6f1cf38d21899632e132cf025e61
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210615154746eucas1p1321b6f1cf38d21899632e132cf025e61
References: <20210602065345.355274-1-hch@lst.de>
        <20210602065345.355274-10-hch@lst.de>
        <CGME20210615154746eucas1p1321b6f1cf38d21899632e132cf025e61@eucas1p1.samsung.com>
        <13b21a07-b7c7-37db-fdc9-77bf174b6f8f@samsung.com>
        <20210615155817.GA31047@lst.de>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Christoph,

On 15.06.2021 17:58, Christoph Hellwig wrote:
> On Tue, Jun 15, 2021 at 05:47:44PM +0200, Marek Szyprowski wrote:
>> On 02.06.2021 08:53, Christoph Hellwig wrote:
>>> Use the blk_mq_alloc_disk API to simplify the gendisk and request_queue
>>> allocation.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> This patch landed in linux-next as commit 6966bb921def ("mtd_blkdevs:
>> use blk_mq_alloc_disk"). It causes the following regression on my QEMU
>> arm64 setup:
> Please try the patch below:
>
> diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
> index 5dc4c966ea73..6ce4bc57f919 100644
> --- a/drivers/mtd/mtd_blkdevs.c
> +++ b/drivers/mtd/mtd_blkdevs.c
> @@ -382,6 +382,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
>   	}
>   
>   	new->disk = gd;
> +	new->rq = new->disk->queue;
>   	gd->private_data = new;
>   	gd->major = tr->major;
>   	gd->first_minor = (new->devnum) << tr->part_bits;

Right, this fixes the issue, thanks. Feel free to add:

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

